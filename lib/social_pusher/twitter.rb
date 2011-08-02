module SocialPusher
  module Twitter

    class Base
      include ActionView::Helpers::TextHelper

      class Unauthorized < Exception; end

      def initialize(params)
        @client = ::TwitterOAuth::Client.new(
            :consumer_key => Rails.application.config.twitter[:consumer_token],
            :consumer_secret => Rails.application.config.twitter[:consumer_secret],
            :token => params[:token],
            :secret => params[:secret]
        )
      end

      def create(data)
        name = data[:name]
        url = data[:url]
        raise Unauthorized unless @client.authorized?
        bitly = ::Bitly.new(Rails.application.config.bitly[:username], Rails.application.config.bitly[:api_key])
        shorten = bitly.shorten(url)
        body = truncate(name, :lenght => 100)
        body += "... #{shorten.short_url}"
        @client.update(body)
      end

    end

    class Post < Base; end
    class Event < Base; end

  end
end
