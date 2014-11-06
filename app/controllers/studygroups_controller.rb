class StudygroupsController < ApplicationController
  def new

  end

  def show

  end

  def add
    groupname = params[:groupname]

    course = params[:course]

    unscheduled = params[:unscheduled]

    private = params[:private]

    date = params[:date]
    year = date[0..3]
    month = date[5..6]
    day = date[8..9]


    tags = params[:tags]


    start_hours = params[:start_hours]
    start_minutes = params[:start_minutes]
    if params[:start_time_tag] == "P.M."
      num_hours = start_hours.to_i + 12
      start_hours = "#{num_hours}"
    end
    start_time = Time.utc(year, month, day, start_hours, start_minutes, 0)

    end_hours = params[:end_hours]
    end_minutes = params[:end_minutes]
    if params[:end_time_tag] == "P.M."
      num_hours = end_hours.to_i + 12
      end_hours = "#{num_hours}"
    end
    end_time = Time.utc(year, month, day, end_hours, end_minutes, 0)


    location = params[:location]

    minsize = params[:minsize]
    maxsize = params[:maxsize]








    t = Time.utc(year, month, day, hours, minutes, 0)


    #Add new group to models
    @message = current_user.create_studygroup(name, course_title, unscheduled=false, start_time=nil, end_time=nil, date=nil,
                                              location=nil, maximum_size=-1, minimum_size=-1,
                                              private=false, recurring=false, recurring_days=nil,
                                              invited_users=nil, tags="",  last_occurrence=nil)


    #Add new group to calendar
    FullcalendarEngine::Event.create({
                                         :title => groupname,
                                         :description => 'N/A',
                                         :starttime => t,
                                         :endtime => t + 60.minute
                                     })
  end
end