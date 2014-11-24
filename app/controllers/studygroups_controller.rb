class StudygroupsController < ApplicationController
  include ApplicationHelper

  def new
  end

  def show
    @studygroup = Studygroup.find(params[:id])
    @owner = User.find(@studygroup.owner_id)
    if !@studygroup.private or @studygroup.users.include?(current_user)
      render 'studygroups/show'
    else
      render 'studygroups/denied'
    end
  end

  def add
    groupname = params[:groupname]
    private = params[:private]
    unscheduled = params[:unscheduled]
    course_title = params[:course]
    maxsize = params[:maxsize]

    if unscheduled == 'true'
      start_time = nil
      end_time = nil
      location = nil
      recurring = nil
      recurring_days = nil
    elsif
      start_hours = params[:start_hours]
      start_minutes = params[:start_minutes]

      year = params[:date][0..3].to_i
      month = params[:date][5..6].to_i
      day = params[:date][8..9].to_i

      if year == 0 || month == 0 || day == 0
        flash_message :error, "Please Enter a date.", true
        render :new
        return
      end

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

      recurring = params[:recurring]
      recurring_days = []
      if params[:sunday] == 'true'
        recurring_days.push(0)
      end
      if params[:monday] == 'true'
        recurring_days.push(1)
      end
      if params[:tuesday] == 'true'
        recurring_days.push(2)
      end
      if params[:wednesday] == 'true'
        recurring_days.push(3)
      end
      if params[:thursday] == 'true'
        recurring_days.push(4)
      end
      if params[:friday] == 'true'
        recurring_days.push(5)
      end
      if params[:saturday] == 'true'
        recurring_days.push(6)
      end
    end

    emails = params[:emails].split(' ')

    rtn_code = current_user.create_studygroup(groupname, course_title, unscheduled, start_time, end_time,
                                                                        location, maxsize,
                                                                        private, recurring, recurring_days,
                                                                        emails, nil)

    # If rtn_code is array, it was not saved and we should get the error messages that prevented the save
    invalid_group = rtn_code.kind_of?(Array) and rtn_code.length == 2 and rtn_code[0] == GlobalConstants::INVALID_STUDYGROUP

    if rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash_message :error, "Course #{params[:course]} does not exist.", true
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash_message :error, "You are not enrolled in the course that Studygroup #{params[:groupname]} is assocated with.", true
    elsif invalid_group
      # Display all errors in flash.now[:error] notice
      error_messages = rtn_code[1]
      error_messages.full_messages.each do |error_msg|
        flash_message :error, error_msg, true
      end
    elsif rtn_code.kind_of?(Studygroup)
      flash_message :success, 'You have successfully created a new Studygroup.', false

      for email in emails
        UserMailer.invite_email(@owner, email, @rtn_code).deliver
      end

      redirect_to welcome_index_path
      return
    end

    render :new
  end
end