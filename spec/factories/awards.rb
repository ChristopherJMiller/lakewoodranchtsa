FactoryGirl.define do
  factory :award do
    name "Test Award"
    value 5
    verified false
    association :user, rank: 1
  end
end
