FactoryGirl.define do
  factory :submission do
    association :accountabilitylog
    association :user
    binderstatus ""
    tasks "MyText"
    goals "MyText"
  end
end
