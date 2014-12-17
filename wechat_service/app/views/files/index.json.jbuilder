json.array!(@wx_files) do |wx_file|
  json.extract! wx_file, :id, :file_name, :file_size, :mime_type, :digest, :description
  json.url wx_file_url(wx_file, format: :json)
end
