module SocialPusher
  module Vkontakte

    module Params

      def self.to_url(params)
        elements = params.inject([]) do |memo, param|
          memo << "#{param[0].to_s}=#{param[1].to_s}"
        end
        elements.join('&')
      end

    end

    class Post

      class CannotCreatePost < Exception; end

      def initialize(token)
        @token = token
      end

      def create(body, captcha = {})
        res = API.request(@token,'wall.post', {:message => body}.merge(captcha))
        if res && res['response']
          return res['response']['post_id']
        end
        if res["error"]
          captcha = Captcha.get(res["error"])
          if captcha
            return [:error, captcha]
          end
        end
        raise CannotCreatePost
      end

    end

    class Event

      class CannotCreateEvent < Exception; end

      def initialize(token)
        @token = token
      end

      def make_event_post(event_fields)
        body = "Event:"
        body << event_fields[:name]
        body << "will start "
        body << event_fields[:start_time].to_s
        body
      end

      def create(data, url)
        body = make_event_post(data)
        body << " #{url}"
        post_data = {:message => body}
        if data[:captcha_key] && data[:captcha_sid]
          post_data.merge!({
            :captcha_key => data[:captcha_key],
            :captcha_sid => data[:captcha_sid]
          })
        end
        res = API.request(@token,'wall.post', post_data )
        if res && res['response']
          return res['response']['post_id']
        end
        if res["error"]
          captcha = Captcha.get(res["error"])
          if captcha
            return [:error, captcha]
          end
        end
        raise CannotCreateEvent
      end

    end

    class Captcha

      def self.get(error)
        if error["error_code"] == 14
          {
            :link => error["captcha_img"],
            :id => error["captcha_sid"]
          }
        end
      end

    end

    class API

      API_HOST = 'https://api.vkontakte.ru/method/'

      def self.request(token, target, params = {})
        path = API_HOST + target
        params.merge!(:access_token => token)
        params = Params.to_url(params)
        path += "?#{params}"
        path = URI.escape(path)
        uri  = URI.parse(path)
        resp = ""
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.start do |http|
          req = Net::HTTP::Get.new("#{uri.path}?#{uri.query}", {"User-Agent" => "ServicePoster"})
          response = http.request(req)
          resp = response.body
        end
        return JSON.parse(resp)
      end

    end

  end
end
