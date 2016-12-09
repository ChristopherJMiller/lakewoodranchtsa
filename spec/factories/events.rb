FactoryGirl.define do
  factory :event do
    name 'Test Event'
    description 'Hello World!'
    max_members_per_team 6
  end
end
