# encoding: utf-8

module Wx
  class Common
    class << self

      def check_signature(wx_app, params)
        token           = wx_app.token
        param_timestamp = params[:timestamp].to_s
        param_nonce     = params[:nonce].to_s
        param_echostr   = params[:echostr].to_s
        param_signature = params[:signature].to_s

        data = [param_timestamp, param_nonce, token]
        signature = Digest::SHA1.hexdigest(data.sort.join(''))

        if signature.downcase != param_signature.downcase
          raise 'Signature Error'
        end

        if param_echostr.present?
          return param_echostr
        end
      end

      def get_wx_message(request)
        xml = request.raw_post.to_s
        xml = xml.gsub(/webwx_msg_cli_ver_0x1<\/xml>$/, "</xml>")
        wx_message = Hash.from_xml(xml)

        wx_message['xml']
      end

      def media_message_type?(message_type)
        ['image', 'voice', 'video'].include?(message_type.to_s.downcase)
      end

      def build_text_message(to_user_open_id, text_message)
        {
          "touser" => to_user_open_id,
          "msgtype" => "text",
          "text" => {
            "content" => text_message
          }
        }
      end

      def build_media_message(media_id, type)
        media = {}
        media['media_id'] = media_id
        message = {}
        message['msgtype'] = type
        message[type] = media

        return message
      end


    end
  end
end