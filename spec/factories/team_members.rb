FactoryGirl.define do
  factory :team_member do
    association :user
    association :team
    admin false
  end
end
