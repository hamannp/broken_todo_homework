FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }

    trait :deleted do
      deleted_at { Time.current }
    end
  end

  factory :item do
    sequence(:action) { |n| "action #{n}" }
    project

    trait :deleted do
      deleted_at { Time.current }
    end
  end
end
