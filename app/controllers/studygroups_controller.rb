class StudygroupsController < ApplicationController
  def new
  end
  def add
    groupname = params[:groupname]
    time = params[:time]
    date = params[:date]
    course = params[:course]

    year = date[0..3]
    month = date[5..6]
    day = date[8..9]
    hour = time[0..1]
    minutes = time[3..4]

    t = Time.utc(year, month, day, hour, minutes, 0)

    #Add new group to models
    puts Studygroup.create_studygroup(current_user, groupname, t, course)
    #Add new group to calendar
    FullcalendarEngine::Event.create({
                                         :title => groupname,
                                         :description => 'N/A',
                                         :starttime => t,
                                         :endtime => t + 60.minute
                                     })
  end
end