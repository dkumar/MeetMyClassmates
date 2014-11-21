class WelcomeController < ApplicationController
  def index
    #Every time we load the page, we reload the calendar events("/fullcalendar_engine/events/get_events")
    #Empty the event calendar database
    FullcalendarEngine::Event.delete_all
    FullcalendarEngine::EventSeries.delete_all

    #Fill the events calendar with events in Studygroups table
    Studygroup.all.each do |studygroup|
      if !studygroup.private or studygroup.users.include?(current_user)
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