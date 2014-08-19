# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :problem do
    name "MyString"
    statement "MyText"
    output "MyString"
    user_id 1
    reusable false
  end
end
