class UsersController < ApplicationController
  include ApplicationHelper

	def show
	end

	def enroll_course
    rtn_code = current_user.enroll_course(params[:course_name])
    if rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash_message :error, "Course #{params[:course_name]} does not exist.", false
    elsif rtn_code == GlobalConstants::USER_ALREADY_ENROLLED
      flash_message :error, "You are already enrolled in #{params[:course_name]}.", false
    else
      flash_message :success, "You have successfully enrolled in #{params[:course_name]}.", false
    end

    redirect_to user_show_path(current_user)
	end

  def unenroll_course
    rtn_code = current_user.unenroll_course(params[:course_name])

    if rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash_message :error, "Course #{params[:course_name]} does not exist.", false
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash_message :error, "You are not enrolled in #{params[:course_name]}.", false
    else
      flash_message :success, "You have successfully unenrolled from #{params[:course_name]}.", false
    end

    redirect_to user_show_path(current_user)
  end

  def join_studygroup
    rtn_code = current_user.join_studygroup(params[:studygroup_id])

    if rtn_code == GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
      flash_message :error, "Studygroup with id #{params[:studygroup_id]} does not exist.", false
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash_message :error, "You are not enrolled in the course that Studygroup #{params[:studygroup_id]} is associated with.", false
    elsif rtn_code == GlobalConstants::COURSE_NONEXISTENT
      flash_message :error, "The course that Studygroup #{params[:studygroup_id]} is associated with does not exist anymore.", false
    elsif rtn_code == GlobalConstants::USER_ALREADY_IN_STUDYGROUP
      flash_message :error, "You are already in Studygroup #{params[:studygroup_id]}.", false
    else
      flash_message :success, "You have successfully joined Studygroup #{params[:studygroup_id]}.", false
    end

    # TODO: display studygroup and course name instead of id in notifications? (same for leave_studygroup)
    redirect_to root_path
  end

  def leave_studygroup
    rtn_code = current_user.leave_studygroup(params[:studygroup_id])

    if rtn_code == GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
      flash_message :error, "Studygroup with id #{params[:studygroup_id]} does not exist.", false
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash_message :error, "You are not enrolled in the course that Studygroup #{params[:studygroup_id]} is associated with.", false
    elsif rtn_code == GlobalConstants::USER_NOT_IN_STUDYGROUP
      flash_message :error, "You are not in Studygroup #{params[:studygroup_id]}.", false
    else
      flash_message :success, "You have successfully left Studygroup #{params[:studygroup_id]}.", false
    end

    redirect_to root_path
  end

  def delete_studygroup
    rtn_code = current_user.delete_studygroup(params[:studygroup_id])

    if rtn_code == GlobalConstants::STUDYGROUP_DOES_NOT_EXIST
      flash_message :error, "Studygroup with id #{params[:studygroup_id]} does not exist.", false
    elsif rtn_code == GlobalConstants::USER_NOT_ALREADY_ENROLLED
      flash_message :error, "You are not enrolled in the course that Studygroup #{params[:studygroup_id]} is associated with.", false
    elsif rtn_code == GlobalConstants::USER_NOT_IN_STUDYGROUP
      flash_message :error, "You are not in Studygroup #{params[:studygroup_id]}.", false
    elsif rtn_code == GlobalConstants::USER_NOT_STUDYGROUP_OWNER
      flash_message :error, "You are not the owner of Studygroup #{params[:studygroup_id]}. Only the owner can delete a Studygroup.", false
    else
      flash_message :success, "You have successfully deleted Studygroup #{params[:studygroup_id]}.", false
    end

    redirect_to root_path
  end
end