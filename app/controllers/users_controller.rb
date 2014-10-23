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
end