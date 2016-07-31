FactoryGirl.define do
  factory :attendee do
    association :user
    association :sign_up_sheet
  end
end
