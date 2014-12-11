class StudygroupsController < ApplicationController
  include ApplicationHelper

  def new
    @studygroup = Studygroup.new
  end

  def show
    @studygroup = Studygroup.find(params[:id])
    @owner = User.find(@studygroup.owner_id)

    if @studygroup.users.include?(current_user) or @studygroup.invited_users.include?(current_user.email) or !@studygroup.private
      render 'show'
    else
      render 'denied'
    end
  end

  def update
    @studygroup = Studygroup.find(params[:id])

    # If update unsuccessful, return to edit and display errors
    unless @studygroup.update_attributes(studygroup_params)
      @studygroup.errors.full_messages.each do |error_msg|
        flash_message :error, error_msg, true
      end
      render :edit
      return
    end

    if params[:schedule_group]
      start_time_tag = params[:start_time_tag]
      end_time_tag = params[:end_time_tag]

      start_hours = params[:start_hours]
      start_minutes = params[:start_minutes]
      start_time = get_time(@studygroup.date.year, @studygroup.date.month, @studygroup.date.day, start_hours, start_minutes, start_time_tag)

      end_hours = params[:end_hours]
      end_minutes = params[:end_minutes]
      end_time = get_time(@studygroup.date.year, @studygroup.date.month, @studygroup.date.day, end_hours, end_minutes, end_time_tag)

      @studygroup.start_time = start_time
      @studygroup.end_time = end_time

      @studygroup.unscheduled = false
      if @studygroup.save
        flash_message :success, "You have successfully scheduled Studygroup #{@studygroup.name}", false
      else
        @studygroup.errors.full_messages.each do |error_msg|
          flash_message :error, error_msg, true
        end
        render :edit
        return
      end
    else
      flash_message :success, "You have successfully edited Studygroup #{@studygroup.name}", false
    end

    redirect_to @studygroup
  end

  def edit
    @studygroup = Studygroup.find(params[:id])
  end

  def add
    groupname = params[:groupname]
    private = params[:private]
    unscheduled = params[:unscheduled]
    course_title = params[:course]
    maxsize = params[:maxsize]
    start_time_tag = params[:start_time_tag]
    end_time_tag = params[:end_time_tag]

    year = params[:date][0..3].to_i
    month = params[:date][5..6].to_i
    day = params[:date][8..9].to_i

    if year == 0 || month == 0 || day == 0
      flash_message :error, "Please Enter a date.", true
      render :new
      return
    end

    date = Date.new(year, month, day)

    location = params[:location]

    if unscheduled == 'true'
      start_time = nil
      end_time = nil
      recurring = nil
      recurring_days = nil
    else
      # The final parameter (0) is used for seconds, we default to times being on half hour intervals
      start_hours = params[:start_hours]
      start_minutes = params[:start_minutes]
      start_time = get_time(year, month, day, start_hours, start_minutes, start_time_tag)

      end_hours = params[:end_hours]
      end_minutes = params[:end_minutes]
      end_time = get_time(year, month, day, end_hours, end_minutes, end_time_tag)

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
    emails = emails.uniq # remove duplicates
    for email in emails
      if email == current_user.email
        emails.delete(email)
      end
    end

    rtn_code = current_user.create_studygroup(groupname, course_title, unscheduled, start_time, end_time,
                                                                        location, maxsize,
                                                                        private, recurring, recurring_days,
                                                                        emails, date, nil)

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
        UserMailer.invite_email(@owner, email, rtn_code).deliver
      end

      redirect_to welcome_index_path
      return
    end

    render :new
  end

  private
    def studygroup_params
      params.require(:studygroup).permit(:name, :start_time, :end_time, :date, :location, :owner_id, :private,
                                         :unscheduled, :invited_users, :recurring, :recurring_days, :last_occurrence)
    end
end