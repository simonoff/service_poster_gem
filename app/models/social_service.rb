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

end
# vim: set sw=2 sts=2 et tw=80 :
