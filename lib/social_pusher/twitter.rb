module SocialPusher
  module Twitter

    class Post
      include ActionView::Helpers::TextHelper

      class Unauthorized < Exception; end

      def initialize(token, secret)
        @client = ::TwitterOAuth::Client.new(
            :consumer_key => Rails.application.config.twitter[:consumer_token],
            :consumer_secret => Rails.application.config.twitter[:consumer_secret],
            :token => token,
            :secret => secret
        )
      end

      def create(name, url)
        raise Unauthorized unless @client.authorized?
        bitly = ::Bitly.new(Rails.application.config.bitly[:username], Rails.application.config.bitly[:api_key])
        shorten = bitly.shorten(url)
        body = truncate(name, :lenght => 100)
        body += "... #{shorten.short_url}"
        @client.update(body)
      end

    end

  end
end
