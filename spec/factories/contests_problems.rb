# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contests_problem, :class => 'ContestsProblems' do
    contest_id 1
    problem_id 1
  end
end
