json.array!(@wx_messages) do |wx_message|
  json.extract! wx_message, :id, :to_user_name, :from_user_name, :create_time, :message_type, :content, :msg_id
  json.url wx_message_url(wx_message, format: :json)
end
