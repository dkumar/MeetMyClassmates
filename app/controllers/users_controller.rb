class UsersController < ActionController::Base
	def show
		if current_user
			#@user = User.find(params[:id])
			render 'constant/banner'
		else

		end
	end
end