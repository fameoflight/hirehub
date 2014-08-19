# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    user_id 1
    contest_id 1
    candidate_email "MyString"
    hash "MyString"
    start_time "2012-05-11 19:42:13"
    score 1
  end
end
