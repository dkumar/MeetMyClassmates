FactoryGirl.define do  factory :message do
    body "MyString"
poster 1
date_time "2014-11-21 17:35:25"


  end

  factory :user do
    email {"user_#{rand(1000).to_s}@berkeley.edu" }
    password '12345678'

    factory :owner do
      email {"user_#{rand(1000).to_s}@berkeley.edu" }
      password '12345678'
    end
  end

  factory :course do
    title 'cs61a' #{rand(1000).to_s}""
  end

  factory :studygroup do
    name  'studygroup'
    start_time  { Time.utc(2015,"jan",1,12,0,0) }
    end_time  { Time.utc(2015,"jan",1,12,0,0) + 5 }
    location 'soda'
    maximum_size { 10 }
    factory :recurring_studygroup do
      start_time  { Time.utc(2015,"jan",1,12,0,0) }
      end_time  { Time.utc(2015,"jan",1,12,0,0) + 5 }
      recurring {true}
      recurring_days {[1, 3]}
      last_occurrence { Date.new(2015, 10, 10) }
    end

    factory :private_studygroup do
      start_time  { Time.utc(2015,"jan",1,12,0,0) }
      end_time  { Time.utc(2015,"jan",1,12,0,0) + 5 }
      private {true}
      invited_users { ['test@berkeley.edu'] }
    end

    factory :private_recurring_studygroup do
      start_time  { Time.utc(2015,"jan",1,12,0,0) }
      end_time  { Time.utc(2015,"jan",1,12,0,0) + 5 }
      recurring {true}
      recurring_days {[1, 3]}
      last_occurrence { Date.new(2015, 10, 10) }
      private {true}
      invited_users { ['test@berkeley.edu'] }
    end

    factory :unscheduled_studygroup do
      unscheduled {true}
    end

    factory :private_unscheduled_studygroup do
      unscheduled {true}
      private {true}
      invited_users { ['test@berkeley.edu'] }
    end

  end
end
