# This will guess the User class
FactoryGirl.define do

  factory :user do
    email "email@example.com"
    password "password"
    first_name "First"
    last_name  "Last"
    is_admin false

    trait :admin do
      is_admin true
    end
  end

  factory :presentation do
    sequence(:title) { |n| "presentation#{n}"}
    date DateTime.now
    location "location"
    description "description"

    trait :long_description do
      description "description description description description description description"
    end
  end

  factory :participation do
    user
    presentation
    is_presenter false

    trait :presenter do
      is_presenter true
    end
  end

  factory :survey do
    order 1
    subject "Git"
    presentation
  end

  factory :question do
    order 1
    prompt "Vinegar pug small batch meditation next level fingerstache flannel messenger bag?"
    response_type "text"
    survey
  end

end