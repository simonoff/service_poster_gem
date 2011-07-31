# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "social_pusher/version"

Gem::Specification.new do |s|
  s.name        = "social_pusher"
  s.version     = SocialPusher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexander Simonov"]
  s.email       = ["alex@simonov.me"]
  s.homepage    = ""
  s.summary     = %q{Pusher to Social Services}
  s.description = %q{Post and Event pusher to social services}
  s.rubyforge_project = "social_pusher"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency 'rails', '3.0.9'
  s.add_dependency 'json'
  s.add_dependency 'omniauth'
  s.add_dependency 'bitly', '0.6.1'
  s.add_dependency 'twitter_oauth', '0.4.3'
end
