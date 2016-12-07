FactoryGirl.define do
  factory :announcement do
    title 'Basic Announcement'
    body 'Hello World!'
    association :user, rank: 1
  end
end
