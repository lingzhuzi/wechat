json.array!(@wx_users) do |wx_user|
  json.extract! wx_user, :id, :nick_name, :remark_name, :open_id, :app_id, :avatar_id, :description
  json.url wx_user_url(wx_user, format: :json)
end
