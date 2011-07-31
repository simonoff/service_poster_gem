Factory.define :event do |e|
  e.association :user, :factory => :user
  e.name Faker::Lorem.words
  e.location 'test location'
  e.date  Time.now.to_date
  e.description Faker::Lorem.paragraph
end