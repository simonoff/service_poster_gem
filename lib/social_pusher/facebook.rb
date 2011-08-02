module SocialPusher
  module Facebook

    class BrokenTarget < Exception; end

    class Post

      class CannotCreatePost < Exception; end

      def initialize(params)
        @token = params[:token]
        raise BrokenTarget unless params[:target]
        target = params[:target]
        @target = target + '/feed'
      end

      def create(body)
        res = Graph.request(@token, @target, {:message => body}, true)
        if res.nil? || res['error']
          raise CannotCreatePost
        end
      end

    end

    class Event

      REQUIREMENTS = [
        :name, :start_time
      ]

      class BrokenEventParams < Exception; end
      class CannotCreateEvent < Exception; end

      def initialize(params)
        token = params[:token]
        raise BrokenTarget unless params[:target]
        target = params[:target]
        @target = target + '/events'
        if accounts = get_all_user_accounts(token)
          page_token = find_page_token(accounts, target)
          if page_token
            @token = page_token
            return true
          end
        end
      end

      def get_all_user_accounts(token)
        response = Graph.request(token, 'me/accounts')
        response["data"] if response && response["data"]
      end

      def find_page_token(accounts, pid)
        page = accounts.select{|x| x["id"] == pid.to_s}.first
        return unless page
        page["access_token"]
      end

      def event_data_valid?(data)
        data_keys = data.keys
        REQUIREMENTS.all?{|req| data_keys.include?(req) }
      end

      def create(data)
        raise BrokenEventParams unless event_data_valid?(data)
        res = Graph.request(@token, @target, data, true)
        if res.nil? || res['error']
          raise CannotCreateEvent
        end
      end

    end

    class Graph < ::SocialPusher::HTTP

      def self.api_host
        "https://graph.facebook.com/"
      end

    end
  end
end
