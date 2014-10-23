class UsersController < ApplicationController

	def show
		if current_user
			#@user = User.find(params[:id])
			#render 'constant/banner'
		else

		end
	end

	def add_course
		p "*" * 80
		p params['q']
		User.enroll(current_user.email, params[:q])
		result = {sucess: true}
		render json: result
	end

	def totalEnrolled
		User.couser_list(current_user.email)
		result = {"count": User.couser_list(current_user.email)}
		render json: result
	end
end