FactoryGirl.define do
  factory :user do
    email {"user_#{rand(1000).to_s}@berkeley.edu" }
    password '12345678'
  end

  factory :course do
    title "cs61a" #{rand(1000).to_s}""
  end

  factory :studygroup do
    name  { "studygroup" }
    time  { Time.current }
    owner_id { FactoryGirl.create(:user).id }
  end
end