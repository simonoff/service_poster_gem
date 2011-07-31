Rails.application.config.twitter = {
    :consumer_token => 'W3F7T6iOtpcgyR0eZ0lU8A',
    :consumer_secret => 'Tg06Bx87QL5lVhMcFcx82xjOSblQoooIavLgOCgV74'
}
Rails.application.config.vkontakte = {
    :consumer_id => '2427192',
    :consumer_secret => 'xSYgTD75gpeeLClNP4ry'
}
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,  Rails.application.config.twitter[:consumer_token], Rails.application.config.twitter[:consumer_secret]
  provider :facebook, '191470260912501', '1787a4b1a9b7a3a2b67d455d2764127d', {:scope => 'publish_stream,offline_access,email,create_event,manage_pages'}
  provider :vkontakte, Rails.application.config.vkontakte[:consumer_id], Rails.application.config.vkontakte[:consumer_secret], {:scope => 'wall,offline'}
end