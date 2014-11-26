# encoding: utf-8

module Wx
  class Api

    GET_USER_INFO_URL    = 'https://api.weixin.qq.com/cgi-bin/user/info'
    GET_ACCESS_TOKEN_URL = "https://api.weixin.qq.com/cgi-bin/token"
    SEND_MESSAGE_URL     = 'https://api.weixin.qq.com/cgi-bin/message/custom/send'
    CREATE_MENU_URL      = 'https://api.weixin.qq.com/cgi-bin/menu/create'
    DOWNLOAD_MEDIA_URL   = 'http://file.api.weixin.qq.com/cgi-bin/media/get'
    UPLOAD_MEDIA_URL     = 'http://file.api.weixin.qq.com/cgi-bin/media/upload'

    class << self

      def get_access_token(ewx_app, force=false)
        unless force
          access_token = ewx_app.access_token
          updated_at   = ewx_app.access_token_updated_at
          if access_token.present? && updated_at.present? && Time.now - updated_at <= 7000.seconds
            return access_token
          end
        end

        params = {}
        params["grant_type"] = "client_credential"
        params["appid"]      = ewx_app.app_id
        params["secret"]     = ewx_app.secret

        response     = get(GET_ACCESS_TOKEN_URL, params)
        access_token = response['access_token']

        ewx_app.access_token            = access_token
        ewx_app.access_token_updated_at = DateTime.now
        ewx_app.save

        return access_token
      end

      def send_message(wx_app, message)
        access_token = get_access_token(wx_app)
        url          = "#{SEND_MESSAGE_URL}?access_token=#{access_token}"
        response     = post(url, message)
        res_msg      = ActiveSupport::JSON.decode(response.body)

        return res_msg
      end

      def upload_media(wx_app, upload_file, type)
        access_token = get_access_token(wx_app)
        url          = "#{UPLOAD_MEDIA_URL}?access_token=#{access_token}&type=#{type}"
        response     = RestClient.post(url, {:media => upload_file})
        res_msg      = ActiveSupport::JSON.decode(response.body)

        return res_msg
      end

      def download_media(wx_app, media_id)
        access_token = get_access_token(wx_app)
        params = {}
        params['access_token'] = access_token
        params['media_id'] = media_id
        response = Request.get(DOWNLOAD_MEDIA_URL, params)

        disposition = response['content-disposition']
        if response['Content-Type'] == 'text/plain' && disposition.blank?
          raise "invalid media_id"
        end

        dir_name  = './tmp/wx/media'
        file_name = "#{dir_name}/#{disposition.scan(/filename="(.*)"/)[0][0]}"
        unless File.exist?(dir_name)
          Dir.mkdir(dir_name)
        end

        open(file_name, 'w+b') do |tmp_file|
          tmp_file.syswrite(response.body)
        end

        return file_name
      end

      def get_user_info(wx_app, user_open_id)
        params = {}
        params["access_token"] = access_tokenget_access_token(wx_app)
        params["openid"]       = user_open_id
        params["lang"]         = 'zh_CN'

        response = get(GET_USER_INFO_URL, params)
        if response['errcode'].present?
          raise "WeiXin Api Error! #{response}"
        end

        return response
      end

      def create_menu(wx_app, menu)
        access_token = get_access_token(wx_app)
        url = "#{CREATE_MENU_URL}?access_token=#{access_token}"
        post(url, menu)
      end

      private

      def get(url, params)
        response      = Request.get(url, params)
        hash_response = ActiveSupport::JSON.decode(response.body)
        hash_response
      end

      def post(url, params)
        response = Request.post(url, params)
        hash_response = ActiveSupport::JSON.decode(response.body)
        hash_response
      end

    end
  end
end