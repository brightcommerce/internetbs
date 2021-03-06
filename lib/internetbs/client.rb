require 'net/http'
require 'net/https'

module InternetBS
  class Client
    @headers = {
      'User-Agent' => InternetBS::VERSION::SUMMARY,
      'Accept' => 'application/json'
    }

    @params = {
      :apikey => InternetBS.api_key,
      :password => InternetBS.api_pwd,
      :responseformat => 'json'
    }
    
    def self.get(endpoint, params = {})
      begin
        uri = URI.parse([InternetBS.api_uri, endpoint].join)
        @params.merge!(params) if params.any?
        uri.query = URI.encode_www_form(@params)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        request = Net::HTTP::Get.new(uri, @headers)
        response = http.request(request)
      rescue StandardError => error
        puts "Request failed (#{error.message})"
      end
    end
    
    def self.post(endpoint, params = {})
      begin
        uri = URI.parse([InternetBS.api_uri, endpoint].join)
        uri.query = URI.encode_www_form(@params)
        body = URI.encode_www_form(params)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        request = Net::HTTP::Post.new(uri, @headers)
        request.add_field "Content-Type", "application/x-www-form-urlencoded"
        request.body = body
        response = http.request(request)
      rescue StandardError => error
        puts "Request failed (#{error.message})"
      end
    end
  end
end
