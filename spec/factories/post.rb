Factory.define :post do |p|
  p.association :user, :factory => :user
  p.name Faker::Lorem.words.join(' ')
  p.body Faker::Lorem.paragraph
end