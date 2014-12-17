json.array!(@key_words) do |wx_key_word|
  json.extract! wx_key_word, :id, :key, :content, :app_id
  json.url wx_key_word_url(wx_key_word, format: :json)
end
