require 'net/http'
require 'net/https'
require 'json'

module SocialPusher
  class HTTP

    def self.api_host
    end

    def self.request(token, target, params = {}, post = false)
      path = api_host + target
      params.merge!(:access_token => token)
      unless post
        params = params.to_query
        path += "?#{params}"
      end
      path = URI.escape(path)
      uri  = URI.parse(path)
      resp = ""
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.start do |http|
        if post
          req = Net::HTTP::Post.new("#{uri.path}", {"User-Agent" => "ServicePoster"})
          req.set_form_data(params)
        else
          req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}", {"User-Agent" => "ServicePoster"})
        end
        response = http.request(req)
        resp = response.body
      end
      return JSON.parse(resp)
    end

  end
end