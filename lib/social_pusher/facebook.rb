require 'net/http'
require 'net/https'
require 'json'

module SocialPusher
  module Facebook

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

      def initialize(token, target)
        @token = token
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

      def initialize(token, target)
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

    module Graph

      GRAPH_HOST = "https://graph.facebook.com/"

      def self.request(token, target, params = {}, post = false)
        path = GRAPH_HOST + target
        params.merge!(:access_token => token)
        unless post
          params = Params.to_url(params)
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
end
