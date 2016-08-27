FactoryGirl.define do
  factory :submission do
    association :accountability_log
    association :user
    binderstatus "Binder Status"
    tasks "Tasks"
    goals "Goals"
  end
end
