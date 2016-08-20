FactoryGirl.define do
  factory :team do
    name "Test Team"
    association :event
  end
end
