OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:twitter, {
  :user_info => {:name => "Joe Smith", :nickname => 'joesmith'},
  :uid => '123456790',
  :credentials => {:token => 'test_token', :secret => 'test_secret'}
})