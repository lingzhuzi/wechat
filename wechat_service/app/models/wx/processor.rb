# encoding: utf-8

module Wx
  class Processor
    class << self
      def deal(wx_app, wx_message)
        wx_message = wx_app.messages.find_by_msg_id(wx_message['MsgId'])
        return if wx_message.present?
        save_wx_message(wx_message)

        message_type = wx_message['MsgType'].to_s.downcase
        case message_type
        when 'text'
        when 'void'
        when 'video'
        when 'image'
        when 'event'
          case event_type
          when 'subscribe'
        end
      end

      def save_wx_message(wx_message, wx_app)
        user_open_id = wx_message['FromUserName']
        wx_user = find_or_create_wx_user(user_open_id, wx_app)
        media_file = download_media_file(wx_message)

        message = Wx::Message.new
        message.user           = wx_user
        message.title          = get_wx_message_title(wx_message)
        message.content        = get_wx_message_content(wx_message)
        message.original       = wx_message.to_json
        message.message_type   = wx_message['MsgType']
        message.event          = wx_message['Event']
        message.event_key      = wx_message['EventKey']
        message.to_user_name   = wx_message['ToUserName']
        message.from_user_name = wx_message['FromUserName']
        message.msg_id         = wx_message['MsgId']
        message.app            = wx_app
        message.author         = wx_user
        message.file           = file
        message.save!

        message
      end

      def download_media_file(wx_message)

      end

      def get_wx_message_title(wx_message)

      end

      def get_wx_message_content(wx_message)
        wx_message['Content'] || wx_message['Description']
      end

      def find_or_create_wx_user(user_open_id, wx_app)
        wx_user = wx_app.users.find_by_open_id(user_open_id)
        return if wx_user.present?

        wx_user = Wx::User.new
        wx_user.open_id = user_open_id
        wx_user.app = wx_app
        wx_user.save!

        delay.update_wx_user_info(wx_user)
        wx_user
      end

      def update_wx_user_info(wx_user)
        wx_app = wx_user.app
        user_info = Wx::Api.get_user_info(wx_app, wx_user.open_id)
        wx_user.nick_name = user_info['nickname']
        wx_user.description = user_info.to_json
        wx_user.save!

        avatar_file_name = download_user_avatar(user_info['headimgurl'])
        create_user_avatar(wx_user, avatar_file_name)
      end

      def download_user_avatar(url)
        response = Request.get(url)

        disposition = response['content-disposition']
        dir_name  = "#{Rails.root}/tmp/wx/avatar/"
        file_name = "#{dir_name}/#{disposition.scan(/filename="(.*)"/)[0][0]}"
        unless File.exist?(dir_name)
          Dir.mkdir(dir_name)
        end

        open(file_name, 'w+b') do |tmp_file|
          tmp_file.syswrite(response.body)
        end

        return file_name
      end

      def create_user_avatar(wx_user, avatar_file_name)
        avatar_file = File.open(avatar_file_name)

        digest    = get_file_digest(avatar_file)
        file_name = File.basename(avatar_file_name)
        ext_name  = File.extname(avatar_file_name)

        wx_file           = Wx::File.new
        wx_file.digest    = digest
        wx_file.file_name = file_name
        wx_file.file_size = avatar_file.size
        wx_file.mime_type = get_mime_type(avatar_file)
        wx_file.user_id   = wx_user.id
        wx_file.save

        wx_user.update_attributes(avatar_id: wx_file.id)

        store_path = "#{Wx::File.store_path}/"
        file_path = "#{store_path}/#{wx_file.digest}.#{extname}"
        return if File.exists?(file_path)
        FileUtils.mkdir_p(store_path) unless Dir.exists?(store_path)
        FileUtils.mv(avatar_file.path, file_path)
      end
    end

    def get_file_digest(file)
      file.rewind
      Digest::SHA1.hexdigest(file.read)
    end

    def get_mime_type(file)
      ext = File.extname(file.original_filename)
      mime_type = MIME::Types.type_for(ext).first
      if mime_type.present?
        return mime_type
      end
      file_type = `file -b -i #{file.tempfile.path}`
      mime_type = file_type.split(';')[0] if file_type.present?
    ensure
      mime_type
    end
  end
end