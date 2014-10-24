# encoding: utf-8
class WxCrypt

  def initialize(token, encoding_aes_key, corp_id)
    if encoding_aes_key.size != 43
      raise 'EncodingAESKey 不正确'
    end
    @token = token
    @corp_id = corp_id
    @aes_key = Base64.decode64(encoding_aes_key + '=')
    @iv = @aes_key[1..16]
  end

  def encrypt(random_str, text)
    unencrypted = random_str + get_network_bytes_order(text.size) + text + @corp_id
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    cipher.encrypt
    cipher.key = @aes_key
    cipher.iv = @iv

    encrypted = cipher.update(unencrypted) + cipher.final
    base64_encrypted = Base64.encode64(encrypted)

    return base64_encrypted
  end

  def decrypt(text)
    original = ''
    begin
      decipher     = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.key = @aes_key
      decipher.iv  = @iv

      encrypted_text  = Base64.decode64(text)
      original = decipher.update(encrypted_text) + decipher.final
    rescue => e
      Rails.logger.error e.backtrace.join("\n")
      raise 'aes解密失败'
    end

    from_corp_id, plain_content = '', ''
    begin
      network_order = original.slice(16, 4)
      msg_size      = recover_network_bytes_order(network_order)
      from_corp_id  = original.slice(20 + msg_size, original.size)
      plain_content = original.slice(20, msg_size)
    rescue => e
      Rails.logger.error e.backtrace.join("\n")
      raise '解密后得到的buffer非法'
    end

    if from_corp_id != @corp_id
      raise 'corpid校验失败'
    end

    return plain_content
  end

  def encrypt_message(reply_message, timestamp, nonce)
    encrypted_text = encrypt(random_str, reply_message)

    if timestamp.blank?
      timestamp = Time.now.to_i.to_s
    end

    if nonce.blank?
      nonce = random_str
    end

    data = [@token, timestamp, nonce, encrypted_text]
    signature = Digest::SHA1.hexdigest(data.sort.join(''))

    xml_content =  "<Encrypt><![CDATA[#{encrypted_text}]]></Encrypt>"
    xml_content << "<MsgSignature><![CDATA[#{signature}]]></MsgSignature>"
    xml_content << "<TimeStamp>#{timestamp}</TimeStamp>"
    xml_content << "<Nonce><![CDATA[#{nonce}]]></Nonce>"
    message     =  "<xml>#{xml_content}</xml>"

    return message
  end

  def decrypt_message(signature, timestamp, nonce, post_data)
    data = Hash.from_xml(post_data)
    encrypted_text = data['xml']['Encrypt']
    verify_signature(signature, timestamp, nonce, encrypted_text)

    result = decrypt(encrypted_text)
    return result
  end

  def verify_url(signature, timestamp, nonce, echostr)
    verify_signature(signature, timestamp, nonce, echostr)
    result = decrypt(echostr)
    return result
  end

  def verify_signature(signature, timestamp, nonce, encrypted_text)
    data = [timestamp, nonce, @token, encrypted_text]
    dev_signature = Digest::SHA1.hexdigest(data.sort.join(''))

    unless signature == dev_signature
      raise ''
    end
  end

  def get_network_bytes_order(source_number)
    array = [source_number, 0, 0, 0]
    order_bytes = array.pack 'N'
    log "order_bytes: #{order_bytes}"
    return order_bytes
  end

  def recover_network_bytes_order(order_bytes)
    source_number = 0
    order_bytes.each_byte do |byte|
      source_number = source_number << 8
      source_number |= byte & 0xFF
    end
    log "source_number: #{source_number}"
    source_number_1 = order_bytes.unpack('N')[0]
    log "source_number_1: #{source_number_1}"
    return source_number
  end

  def random_str
    base = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    result = ''
    random = Random.new
    16.times do |i|
      number = random.rand(base.size)
      result << base[number]
    end

    return result
  end

  def log(text)
    Rails.logger.debug "---> #{text}"
  end
end