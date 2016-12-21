FactoryGirl.define do
  factory :team do
    name 'Test Team'
    closed false
    association :event
  end
end
