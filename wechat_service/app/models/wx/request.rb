# encoding: utf-8

module Wx
  class Request
    class << self

      def get(url, params={})
        uri = URI.parse(url)
        query_str = URI.encode_www_form(params || {})
        if uri.query
          uri.query += "&#{query_str}" if query_str
        else
          uri.query = query_str
        end
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme.downcase == 'https'
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
        return response
      end

      def post(url, params)
        Delayed::Worker.logger.debug "----#{Time.now.to_f}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true if uri.scheme.downcase == 'https'
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = params.to_json
        Delayed::Worker.logger.debug "------#{Time.now.to_f}"
        response = http.request(request)
        Delayed::Worker.logger.debug "----#{Time.now.to_f}"
        return response
      end
    end
  end
end