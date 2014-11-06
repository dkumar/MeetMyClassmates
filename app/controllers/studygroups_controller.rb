class StudygroupsController < ApplicationController
  def new

  end

  def show

  end

  def add
    groupname = params[:groupname]
    course_title = params[:course]
    unscheduled = (1 == params[:unscheduled].to_i)

    start_hours = params[:start_hours]
    start_minutes = params[:start_minutes]

    year = params[:date][0..3].to_i
    month = params[:date][5..6].to_i
    day = params[:date][8..9].to_i
    date = Date.new(year, month, day)

    if params[:start_time_tag] == "P.M."
      num_hours = start_hours.to_i + 12
      start_hours = "#{num_hours}"
    end
    # The final parameter(0) is used for seconds, we default to times being on half hour intervals
    start_time = Time.utc(year, month, day, start_hours, start_minutes, 0)

    end_hours = params[:end_hours]
    end_minutes = params[:end_minutes]
    if params[:end_time_tag] == "P.M."
      num_hours = end_hours.to_i + 12
      end_hours = "#{num_hours}"
    end
    # The final parameter(0) is used for seconds, we default to times being on half hour intervals
    end_time = Time.utc(year, month, day, end_hours, end_minutes, 0)

    location = params[:location]
    maxsize = params[:maxsize]
    minsize = params[:minsize]

    private = (1 == params[:private].to_i)
    recurring = (1 == params[:recurring].to_i)
    recurring_days = []
    if params[:sunday].to_i == 1
      recurring_days.push(0)
    end
    if params[:monday].to_i == 1
      recurring_days.push(1)
    end
    if params[:tuesday].to_i == 1
      recurring_days.push(2)
    end
    if params[:wednesday].to_i == 1
      recurring_days.push(3)
    end
    if params[:thursday].to_i == 1
      recurring_days.push(4)
    end
    if params[:friday].to_i == 1
      recurring_days.push(5)
    end
    if params[:saturday].to_i == 1
      recurring_days.push(6)
    end

    emails = params[:emails].split(' ')
    tags = params[:tags].split(' ')

    #Add new group to models
    new_studygroup = current_user.create_studygroup(groupname, course_title, unscheduled, start_time, end_time, date,
                                              location, maxsize, minsize,
                                              private, recurring, recurring_days,
                                              emails,  tags, nil)
    @message = @message.name
    #Add new group to calendar
    FullcalendarEngine::Event.create({
                                         :title => groupname,
                                         :description => 'N/A',
                                         :starttime => start_time,
                                         :endtime => end_time
                                     })




  end
end