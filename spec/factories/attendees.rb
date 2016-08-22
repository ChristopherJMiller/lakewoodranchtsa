FactoryGirl.define do
  factory :attendee do
    association :user, rank: 1
    association :sign_up_sheet
  end
end
