FactoryGirl.define do
  factory :user do
    name "John Doe"
    email "test@test.com"
    password "password1234"
    password_confirmation "password1234"

    verified true
    verify_token ''

    rank 0
  end
end
