module SocialPusher
  module Vkontakte

    class Post

      class CannotCreatePost < Exception; end

      def initialize(params)
        @token = params[:token]
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

      def initialize(params)
        @token = params[:token]
      end

      def make_event_post(event_fields)
        body = "Event:"
        body << event_fields[:name]
        body << "will start "
        body << event_fields[:start_time].to_s
        body << " details at #{event_fields[:url]}"
        body
      end

      def create(data)
        body = make_event_post(data)
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

    class API < ::SocialPusher::HTTP
      def self.api_host
        'https://api.vkontakte.ru/method/'
      end
    end

  end
end
