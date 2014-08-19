# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission do
    user_id 1
    problem_id 1
    submission_text "MyText"
    judged false
  end
end
