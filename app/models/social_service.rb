class SocialService < ActiveRecord::Base
  belongs_to :user

  class << self

    def auth_token_exists?(user_id, provider, uid)
      SocialService.where(:user_id => user_id, :provider => provider, :uid => uid.to_s).exists?
    end

    def get_auth_info(omniauth)
      uid = omniauth["uid"].to_s
      token = omniauth["credentials"]["token"]
      secret = omniauth["credentials"]["secret"]
      { :uid => uid, :token => token, :secret => secret, :provider => omniauth["provider"]}
    rescue
    end

  end

  def push_post(id, captcha = nil, captcha_id = nil)
    __send__("push_post_to_#{provider}".to_sym, id, captcha, captcha_id)
  end

  def push_post_to_twitter(id, captcha = nil, captcha_id = nil)
    post = Post.find(id)
    twitter_post = SocialPusher::Twitter::Post.new(token,secret)
    url = Rails.application.routes.url_helpers.post_url(id, :host => 'socialposter.local' )
    twitter_post.create(post.name, url)
  end

  def push_post_to_vkontakte(id, captcha = nil, captcha_id = nil)
    post = Post.find(id)
    vkontakte_post = SocialPusher::Vkontakte::Post.new(token)
    captcha_data = {}
    if captcha && captcha_id
      captcha_data.merge!({
        :captcha_sid => captcha_id,
        :captcha_key => captcha
      })
    end
    vkontakte_post.create(post.body, captcha_data)
  end

  def push_post_to_facebook(id, captcha = nil, captcha_id = nil)
    post = Post.find(id)
    facebook_post = SocialPusher::Facebook::Post.new(token, fb_page_id)
    facebook_post.create(post.body)
  end

  def push_event(id, captcha = nil, captcha_id = nil)
    case provider
    when "twitter"
      push_event_to_twitter(id)
    when "facebook"
      push_event_to_facebook(id)
    when "vkontakte"
      push_event_to_vkontakte(id, captcha, captcha_id)
    end
  end

  def push_event_to_twitter(id)
    event = Event.find(id)
    twitter_post = SocialPusher::Twitter::Post.new(token,secret)
    url = Rails.application.routes.url_helpers.event_url(id, :host => 'socialposter.local' )
    twitter_post.create(event.name, url)
  end

  def push_event_to_vkontakte(id, captcha = nil, captcha_id = nil)
    event = Event.find(id)
    url = Rails.application.routes.url_helpers.event_url(id, :host => 'socialposter.local' )
    vkontakte_event = SocialPusher::Vkontakte::Event.new(token)
    data = {
      :name => event.name,
      :start_time => event.date.to_time
    }
    if captcha && captcha_id
      data.merge!({
        :captcha_sid => captcha_id,
        :captcha_key => captcha
      })
    end
    res = vkontakte_event.create(data, url)
    if res.is_a?(Array)
      if res[0] == :error
        return [:captcha, res[1]]
      end
    end
  end

  def push_event_to_facebook(id)
    event = Event.find(id)
    facebook_event = SocialPusher::Facebook::Event.new(token, fb_page_id)
    if facebook_event
      facebook_event.create({
        :name => event.name,
        :start_time => event.date.to_time.to_i
      })
    end
  end

end
# vim: set sw=2 sts=2 et tw=80 :
