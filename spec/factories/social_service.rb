Factory.define :social_service do |t|
  t.association :user, :factory => :user
  t.uid '123456790'
  t.token 'test_token1'
  t.secret 'test_secret1'
  t.provider 'twitter'
end

Factory.define :twitter_service, :class => SocialService do |t|
  t.association :user, :factory => :user
  t.uid '345918746'
  t.token '345918746-uXiIHgAPJLMV1yW6VOmNBhbiFRzRAPgwCpz1ebMd'
  t.secret 'ndE1eCMEQiLIyncG2Uuojm2WF8zTchZ2h1Ia6J5yY'
  t.provider 'twitter'
end

Factory.define :facebook_service, :class => SocialService do |t|
  t.association :user, :factory => :user
  t.uid '100002746836446'
  t.token '191470260912501|e8fbcd6350e503c11613bb5a.1-100002746836446|k8do1SwpeLd6ZTrfC7i5svxJnFk'
  t.fb_page_id '138378756245753'
  t.provider 'facebook'
end

Factory.define :vkontakte_service, :class => SocialService do |t|
  t.association :user, :factory => :user
  t.uid '142426339'
  t.token '9451949b9c2cd4789c2cd478d19c09dd4019c2c9c2df478f992907cd1430e29'
  t.provider 'vkontakte'
end
