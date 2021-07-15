FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task#{n}" }
    sequence(:description) { |n| "description #{n}\ndescription #{n}}" }
  end
end
