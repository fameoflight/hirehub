# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest do
    name "MyString"
    user_id 1
    start_time "2012-05-09 20:03:18"
    duration 1
  end
end
