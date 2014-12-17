# encoding: utf-8

module Wx
  class Processor
    class << self
      def deal(wx_app, wx_message)
        message = wx_app.messages.find_by_msg_id(wx_message['MsgId'])
        return if message.present?
        save_wx_message(wx_message, wx_app)
        send_auto_reply_if_key_word(wx_message, wx_app)

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
      end

      def send_auto_reply_if_key_word(wx_message, wx_app)
        key = wx_message['Content']
        return if key.blank?
        key_word = wx_app.key_words.find_by_key(key)
        return if key_word.blank?
        auto_reply = key_word.content
        send_auto_reply(auto_reply, wx_app, wx_message['FromUserName'])
      end

      def send_auto_reply(reply_content, wx_app, user_open_id)
        message = Wx::Common.build_text_message(user_open_id, reply_content)
        save_send_message(message, wx_app)
        Wx::Api.send_message(wx_app, message)
      end

      def save_send_message(message_hash, app)
        message = Message.new
        message.title          = ''
        message.content        = message_hash['text']['content']
        message.original       = message_hash.to_json
        message.message_type   = 'text'
        message.to_user_name   = message_hash['touser']
        message.from_user_name = app.wx_id
        message.app_id         = app.id
        message.save!
      end

      def save_wx_message(wx_message, wx_app)
        user_open_id = wx_message['FromUserName']
        wx_user = find_or_create_wx_user(user_open_id, wx_app)
        media_file = download_media_file(wx_message)

        message = Message.new
        message.title          = get_wx_message_title(wx_message)
        message.content        = get_wx_message_content(wx_message)
        message.original       = wx_message.to_json
        message.message_type   = wx_message['MsgType']
        message.event          = wx_message['Event']
        message.event_key      = wx_message['EventKey']
        message.to_user_name   = wx_message['ToUserName']
        message.from_user_name = wx_message['FromUserName']
        message.msg_id         = wx_message['MsgId']
        message.app_id         = wx_app.id
        message.author_id      = wx_user.id
        message.file_id        = media_file.id if media_file.present?
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
        wx_user = wx_app.wx_users.find_by_open_id(user_open_id)
        return wx_user if wx_user.present?

        wx_user = User.new
        wx_user.email    = "#{user_open_id}@localhost.com"
        wx_user.password = '123456789'
        wx_user.open_id  = user_open_id
        wx_user.app_id   = wx_app.id
        wx_user.save!

        update_wx_user_info(wx_user)
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

        wx_user
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

        wx_file           = File.new
        wx_file.digest    = digest
        wx_file.file_name = file_name
        wx_file.file_size = avatar_file.size
        wx_file.mime_type = get_mime_type(avatar_file)
        wx_file.user_id   = wx_user.id
        wx_file.save

        wx_user.update_attributes(avatar_id: wx_file.id)

        store_path = "#{File.store_path}/"
        file_path = "#{store_path}/#{wx_file.digest}.#{extname}"
        return if File.exists?(file_path)
        FileUtils.mkdir_p(store_path) unless Dir.exists?(store_path)
        FileUtils.mv(avatar_file.path, file_path)
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
end