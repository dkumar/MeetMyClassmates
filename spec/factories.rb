FactoryGirl.define do
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
    start_time  { Time.current }
    end_time  { Time.current + 5 }
    
    factory :recurring_studygroup do
      start_time  { Time.current }
      end_time  { Time.current + 5 }
      recurring {true}
      recurring_days {[1, 3]}
      last_occurrence { Date.new(2015, 10, 10) }
    end

    factory :private_studygroup do
      start_time  { Time.current }
      end_time  { Time.current + 5 }
      private {true}
    end

    factory :private_recurring_studygroup do
      start_time  { Time.current }
      end_time  { Time.current + 5 }
      recurring {true}
      recurring_days {[1, 3]}
      last_occurrence { Date.new(2015, 10, 10) }
      private {true}
    end

    factory :unscheduled_studygroup do
      unscheduled {true}
    end

    factory :private_unscheduled_studygroup do
      unscheduled {true}
      private {true}
    end

  end
end
