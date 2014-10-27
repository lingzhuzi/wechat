# encoding: utf-8

class WxCommon
  class << self
    def decrypt_message(wx_crypt, params, request)
      signature = params[:msg_signature]
      timestamp = params[:timestamp]
      nonce     = params[:nonce]

      post_data   = request.raw_post.to_s
      xml_message = wx_crypt.decrypt_message(signature, timestamp, nonce, post_data)
      message     = Hash.from_xml(xml_message)

      return message['xml']
    end
  end
end