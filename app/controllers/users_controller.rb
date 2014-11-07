class UsersController < ApplicationController

	def show
	end

	def enroll_course
    rtn_code = current_user.enroll_course(params[:course_name])

    if rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash.now[:error] = "Error: Course #{params[:course_name]} does not exist."
    elsif rtn_code == GlobalConstants::USER_ALREADY_ENROLLED
      flash.now[:error] = "Error: You are already enrolled in #{params[:course_name]}."
    else
      flash.now[:success] = "Success: You have successfully enrolled in #{params[:course_name]}."
    end

    render :show
	end

  def unenroll_course
    rtn_code = current_user.unenroll_course(params[:course_name])

    if rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash.now[:error] = "Error: Course #{params[:course_name]} does not exist."
    elsif rtn_code == GlobalConstants::USER_ALREADY_ENROLLED
      flash.now[:error] = "Error: You are already enrolled in #{params[:course_name]}."
    else
      flash.now[:success] = "Success: You have successfully unenrolled in #{params[:course_name]}."
    end

    render :show
  end

  def join_studygroup
    rtn_code = current_user.join_studygroup(params[:studygroup_id])

    if rtn_code == GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
      flash.now[:error] = "Error: Studygroup with id #{params[:studygroup_id]} does not exist."
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash.now[:error] = "Error: You are not enrolled in the course that Studygroup #{params[:studygroup_id]} is associated with."
    elsif rtn_code == GlobalConstants::USER_ALREADY_IN_STUDYGROUP
      flash.now[:error] = "Error: You are already in Studygroup #{params[:studygroup_id]}."
    else
      flash.now[:success] = "Success: You have successfully joined Studygroup #{params[:studygroup_id]}."
    end

    # TODO: change to redirect to correct page (same for leave_studygroup)
    # TODO: display studygroup and course name instead of id in notifications? (same for leave_studygroup)
    render json: {join_result: rtn_code}
  end

  def leave_studygroups
    rtn_code = current_user.leave_studygroup(params[:studygroup_id])

    if rtn_code == GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
      flash.now[:error] = "Error: Studygroup with id #{params[:studygroup_id]} does not exist."
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash.now[:error] = "Error: You are not enrolled in the course that Studygroup #{params[:studygroup_id]} is associated with."
    elsif rtn_code == GlobalConstants::USER_NOT_IN_STUDYGROUP
      flash.now[:error] = "Error: You are not in Studygroup #{params[:studygroup_id]}."
    else
      flash.now[:success] = "Success: You have successfully joined Studygroup #{params[:studygroup_id]}."
    end

    render json: {leave_result: rtn_code}
  end
end