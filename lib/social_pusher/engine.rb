require "social_pusher"
require "rails"

module SocialPusher
 class Engine < Rails::Engine
    config.mount_at = '/'
  end
end
# vim: set sw=2 sts=2 et tw=80 :
