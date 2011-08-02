module SocialPusher
  if defined?(Rails)
    require 'social_pusher/engine'
    require 'social_pusher/http_request'
    require 'social_pusher/facebook'
    require 'social_pusher/twitter'
    require 'social_pusher/vkontakte'
    require 'postable/base'
  end
end


