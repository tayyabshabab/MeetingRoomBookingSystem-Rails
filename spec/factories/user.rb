FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "test123"
    password_confirmation "test123"

    factory :admin do
      admin true
    end
  end

  factory :invalid_user, parent: :user do |u|
    u.name nil
    u.email nil
  end
end