class UsersController < ApplicationController

	def show
		if current_user
			#@user = User.find(params[:id])
			#render 'constant/banner'
		else

		end
	end

	def enroll_course
    p '*' * 80
		enrollResult = User.enroll(current_user, params[:course])
		render json: { enrollResult: enrollResult }
	end

  def unenroll_course
    User.unenroll(current_user, params[:course])
    result = {success: true}
    render json: result
  end

  def join_studygroup

  end


  def leave_studygroup

  end

end