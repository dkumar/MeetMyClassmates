class WelcomeController < ApplicationController
  def index
    #Every time we load the page, we reload the calendar events("/fullcalendar_engine/events/get_events")
    #Empty the event calendar database
    FullcalendarEngine::Event.delete_all

    #Fill the events calendar with events in Studygroups table
    Studygroup.all.each do |studygroup|
      # initial check if group is private - if it is and doesn't include users,
      # don't create it in the first place for the calendar
      if !studygroup.private or studygroup.users.include?(current_user) or !studygroup.unscheduled
        full = studygroup.users.size == studygroup.maximum_size
        # Case 1: If the group is recurring
        if studygroup.recurring
          date = Date.parse(studygroup.start_time.to_s)
          offset = 0
          if date.sunday?
            offset = 0
          elsif date.monday?
            offset = -1
          elsif date.tuesday?
            offset = -2
          elsif date.wednesday?
            offset = -3
          elsif date.thursday?
            offset = -4
          elsif date.friday?
            offset = -5
          elsif date.saturday?
            offset = -6
          end
          for day in studygroup.recurring_days
            for i in 0..12
              new_date = date + day.to_i + offset + 7*i
              new_start_time = Time.utc(new_date.year, new_date.month, new_date.day, studygroup.start_time.hour, studygroup.start_time.min, studygroup.start_time.sec)
              new_end_time = Time.utc(new_date.year, new_date.month, new_date.day, studygroup.end_time.hour, studygroup.end_time.min, studygroup.end_time.sec)

              FullcalendarEngine::Event.create({
                                                  title: studygroup.name,
                                                  description: Course.find(studygroup.course_id).title.to_s + "," + studygroup.id.to_s + "," + full.to_s,
                                                  starttime: new_start_time,
                                                  endtime: new_end_time
                                               })
            end
          end
          # Edge case of recurring studygroups: if no recurring days are selected
          # just make the original date the recurring day
          if studygroup.recurring_days.empty?
            for i in 0..12
              new_date = date + 7*i
              new_start_time = Time.utc(new_date.year, new_date.month, new_date.day, studygroup.start_time.hour, studygroup.start_time.min, studygroup.start_time.sec)
              new_end_time = Time.utc(new_date.year, new_date.month, new_date.day, studygroup.end_time.hour, studygroup.end_time.min, studygroup.end_time.sec)
              FullcalendarEngine::Event.create({
                                                  title: studygroup.name,
                                                  description: Course.find(studygroup.course_id).title.to_s + "," + studygroup.id.to_s + "," + full.to_s,
                                                  starttime: new_start_time,
                                                  endtime: new_end_time
                                               })
            end
          end
        # Case 2: The studygroup is not recurring
        else
          FullcalendarEngine::Event.create({
                                              title: studygroup.name,
                                              description: Course.find(studygroup.course_id).title.to_s + "," + studygroup.id.to_s + "," + full.to_s,
                                              starttime: studygroup.start_time,
                                              endtime: studygroup.end_time
                                           })
        end
      end
    end
  end
  end
