# encoding: utf-8
class WxCrypt

  def initialize(token, encoding_aes_key, corp_id)
    if encoding_aes_key.size != 43
      raise 'EncodingAESKey 不正确'
    end
    @token = token
    @corp_id = corp_id
    @aes_key = Base64.decode64(encoding_aes_key + '=')
    @iv = @aes_key[0...16]
  end

  def encrypt_message(reply_message, timestamp, nonce)
    encrypted_text = encrypt(random_str, reply_message)

    timestamp = Time.now.to_i if timestamp.blank?
    nonce     = random_str    if nonce.blank?

    data = [@token, timestamp.to_s, nonce, encrypted_text]
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

  private

  def encrypt(random_str, text)
    encoded_text = text.force_encoding("ASCII-8BIT")
    unencrypted = random_str
    unencrypted << get_network_bytes_order(encoded_text.size)
    unencrypted << encoded_text
    unencrypted << @corp_id
    unencrypted << pkcs7_encode(unencrypted.size)

    begin
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.encrypt
      cipher.padding = 0
      cipher.key = @aes_key
      cipher.iv = @iv

      encrypted = cipher.update(unencrypted) + cipher.final
      base64_encrypted = Base64.encode64(encrypted)

      return base64_encrypted
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      raise "aes加密失败"
    end
  end

  def decrypt(text)
    original = ''
    begin
      decipher     = OpenSSL::Cipher::AES.new(256, :CBC)
      decipher.decrypt
      decipher.padding = 0
      decipher.key = @aes_key
      decipher.iv  = @iv

      encrypted_text  = Base64.decode64(text)
      original = decipher.update(encrypted_text) + decipher.final
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      raise 'aes解密失败'
    end

    from_corp_id, plain_content = '', ''
    begin
      original      = pkcs7_decode(original)
      network_order = original.slice(16, 4)
      msg_size      = recover_network_bytes_order(network_order)
      from_corp_id  = original.slice(20 + msg_size, original.size)
      plain_content = original.slice(20, msg_size)
    rescue => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      raise '解密后得到的buffer非法'
    end

    if from_corp_id != @corp_id
      raise 'corpid校验失败'
    end

    return plain_content
  end

  def pkcs7_encode(count)
    block_size = 32
    charset = 'utf-8'
    amount_to_pad = block_size - (count % block_size)
    if amount_to_pad == 0
      amount_to_pad = 32
    end
    pad_char = amount_to_pad.chr

    tmp = ''
    amount_to_pad.times do |i|
      tmp += pad_char
    end

    chars = tmp.encode(charset)
    return chars
  end

  def pkcs7_decode(decrypted_text)
    byte = decrypted_text[decrypted_text.size - 1]
    pad  = byte.unpack('c')[0]
    if pad < 1 || pad > 32
      pad = 0
    end
    size = decrypted_text.size - pad
    plain_text = decrypted_text[0...size]
    return plain_text
  end


  def verify_signature(signature, timestamp, nonce, encrypted_text)
    data = [timestamp, nonce, @token, encrypted_text]
    dev_signature = Digest::SHA1.hexdigest(data.sort.join(''))

    unless signature == dev_signature
      raise '签名验证错误'
    end
  end

  def get_network_bytes_order(source_number)
    array = [source_number, 0, 0, 0]
    order_bytes = array.pack 'N'
    return order_bytes
  end

  def recover_network_bytes_order(order_bytes)
    source_number = order_bytes.unpack('N')[0]
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

end