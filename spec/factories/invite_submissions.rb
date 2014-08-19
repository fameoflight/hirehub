# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite_submission do
    invite_id 1
    problem_id 1
    submission_id 1
    score 1
  end
end
