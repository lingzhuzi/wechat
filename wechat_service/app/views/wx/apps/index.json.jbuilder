json.array!(@wx_apps) do |wx_app|
  json.extract! wx_app, :id, :name, :icon_id, :wx_id, :app_id, :sceret
  json.url wx_app_url(wx_app, format: :json)
end
