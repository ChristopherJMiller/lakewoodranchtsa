FactoryGirl.define do
  factory :submission do
    association :accountabilitylog
    association :user
    binderstatus "Binder Status"
    tasks "Tasks"
    goals "Goals"
  end
end
