class UsersController < ApplicationController

	def show
		if current_user
			#@user = User.find(params[:id])
			#render 'constant/banner'
    else

		end
	end

	def enroll_course
		User.enroll_course(current_user, params[:course])
    render 'users/show'
	end

  def unenroll_course
    User.unenroll_course(current_user, params[:course])
    render 'users/show'
  end

  def join_studygroup
    join_result = User.join_studygroup(current_user, params[:studygroup_id])
    render json: {join_result: join_result}
  end

  def leave_studygroups
    leave_result = User.leave_studygroup(current_user, params[:studygroup_id])
    render json: {leave_result: leave_result}
  end

  def list_courses
    list_result = User.list_courses(current_user)
    render json: {list_result: list_result}
  end

end