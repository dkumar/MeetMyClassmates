class StudygroupsController < ApplicationController
  def new
  end

  def show
    @studygroup = Studygroup.find(params[:id])
    if !@studygroup.private or @studygroup.users.include?(current_user)
      @owner = User.find(@studygroup.owner_id)
      render 'studygroups/show'
    else
      render 'studygroups/denied'
    end
  end

  def add
    groupname = params[:groupname]
    course_title = params[:course]
    unscheduled = params[:unscheduled]

    start_hours = params[:start_hours]
    start_minutes = params[:start_minutes]

    year = params[:date][0..3].to_i
    month = params[:date][5..6].to_i
    day = params[:date][8..9].to_i
    date = Date.new(year, month, day)

    if params[:start_time_tag] == "P.M." && start_hours != "12"
      num_hours = start_hours.to_i + 12
      start_hours = num_hours.to_s
    elsif params[:start_time_tag] == "P.M." && start_hours == "12"
      start_hours = "12"
    elsif params[:start_time_tag] == "A.M." && start_hours == "12"
      start_hours = "0"
    end
    # The final parameter (0) is used for seconds, we default to times being on half hour intervals
    start_time = Time.utc(year, month, day, start_hours, start_minutes, 0)

    end_hours = params[:end_hours]
    end_minutes = params[:end_minutes]
    if params[:end_time_tag] == "P.M." && end_hours != "12"
      num_hours = end_hours.to_i + 12
      end_hours = num_hours.to_s
    elsif params[:end_time_tag] == "P.M." && end_hours == "12"
      end_hours = "12"
    elsif params[:end_time_tag] == "A.M." && end_hours == "12"
      end_hours = "0"
    end
    # The final parameter (0) is used for seconds, we default to times being on half hour intervals
    end_time = Time.utc(year, month, day, end_hours, end_minutes, 0)

    location = params[:location]
    maxsize = params[:maxsize]
    minsize = params[:minsize]

    private = params[:private]

    recurring = params[:recurring]
    recurring_days = []
    if params[:sunday]
      recurring_days.push(0)
    end
    if params[:monday]
      recurring_days.push(1)
    end
    if params[:tuesday]
      recurring_days.push(2)
    end
    if params[:wednesday]
      recurring_days.push(3)
    end
    if params[:thursday]
      recurring_days.push(4)
    end
    if params[:friday]
      recurring_days.push(5)
    end
    if params[:saturday]
      recurring_days.push(6)
    end

    emails = params[:emails].split(' ')
    tags = params[:tags].split(' ')

    @rtn_code = current_user.create_studygroup(groupname, course_title, unscheduled, start_time, end_time, date,
                                                                        location, maxsize, minsize,
                                                                        private, recurring, recurring_days,
                                                                        emails, tags, nil)

    if @rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash[:error] = "Error: Course #{params[:course]} does not exist."
    elsif @rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash[:error] = "Error: You are not enrolled in the course that Studygroup #{params[:groupname]} is assocated with."
    else
      flash[:success] = 'Success: You have successfully created a new Studygroup.'

      # Add to calendar
      FullcalendarEngine::Event.create({
                                           title: groupname,
                                           description: course_title,
                                           starttime: start_time,
                                           endtime: end_time,
                                           id: @rtn_code.id
                                       })
    end

    for email in emails
      UserMailer.invite_email(@owner, email, @rtn_code).deliver
    end

    redirect_to welcome_index_path
  end

  def show_unscheduled
  end
end