FactoryGirl.define do
  factory :project_assignment do
    association :project, factory: :project
    association :user, factory: :user
    started_at "2020-03-22 09:50:00"
    finished_at "2020-03-22 23:40:00"
  end
end