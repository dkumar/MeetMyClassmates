class UsersController < ApplicationController

	def show
		if current_user
			#@user = User.find(params[:id])
			#render 'constant/banner'
    else

		end
	end

	def enroll_course
    current_user.enroll_course(params[:course_name])
    render :show
	end

  def unenroll_course
    current_user.unenroll_course(params[:course_name])
    render :show
  end

  def join_studygroup
    join_result = current_user.join_studygroup(params[:studygroup_id])
    render json: {join_result: join_result}
  end

  def leave_studygroups
    leave_result = current_user.leave_studygroup(params[:studygroup_id])
    render json: {leave_result: leave_result}
  end
end