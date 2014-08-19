# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :interview do
    user_id 1
    candidate_name "MyString"
    candidate_email "MyString"
    candidate_id 1
    start_time "2012-06-08 21:13:06"
    end_time "2012-06-08 21:13:06"
    timezone "MyString"
    instruction "MyText"
    url_hash "MyString"
  end
end
