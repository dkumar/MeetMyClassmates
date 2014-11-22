class WelcomeController < ApplicationController
  def index
    #Every time we load the page, we reload the calendar events("/fullcalendar_engine/events/get_events")
    #Empty the event calendar database
    FullcalendarEngine::Event.delete_all
    FullcalendarEngine::EventSeries.delete_all

    #Fill the events calendar with events in Studygroups table
    Studygroup.all.each do |studygroup|
      if !studygroup.private or studygroup.users.include?(current_user)
        if studygroup.recurring
          date = Date.parse(studygroup.start_time.to_s)
          offset = 0
          if date.sunday?
            offset = 0
          elsif date.monday?
            offset = 1
          elsif date.tuesday?
            offset = 2
          elsif date.wednesday?
            offset = 3
          elsif date.thursday?
            offset = 4
          elsif date.friday?
            offset = 5
          elsif date.saturday?
            offset = 6
          end

        else
          FullcalendarEngine::Event.create({
                                               title: studygroup.name,
                                               description: Course.find(studygroup.course_id).title,
                                               starttime: studygroup.start_time,
                                               endtime: studygroup.end_time,
                                               id: studygroup.id
                                           })
        end
      end
    end
  end
end