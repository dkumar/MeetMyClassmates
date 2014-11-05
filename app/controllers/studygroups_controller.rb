class StudygroupsController < ApplicationController
  def new

  end

  def show

  end

  def add
    groupname = params[:groupname]
    date = params[:date]
    course = params[:course]

    year = date[0..3]
    month = date[5..6]
    day = date[8..9]


    hours = params[:hours]
    minutes = params[:minutes]
    if params[:time_tag] == "P.M."
      num_hours = hours.to_i + 12
      hours = "#{num_hours}"
    end



    t = Time.utc(year, month, day, hours, minutes, 0)


    #Add new group to models
    puts "**************************************************"
    puts params
    puts "**************************************************"
    @message = Studygroup.create_studygroup(current_user, groupname, t, course)
    #Add new group to calendar
    FullcalendarEngine::Event.create({
                                         :title => groupname,
                                         :description => 'N/A',
                                         :starttime => t,
                                         :endtime => t + 60.minute
                                     })
  end
end