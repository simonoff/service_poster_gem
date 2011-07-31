Factory.define :user do |u|
  u.sequence(:email) {|n| "user#{n}@test.com" }
  u.password 'temp123'
end