class DashboardController < ApplicationController

	def index
		if signed_in? && current_user.role_id == 2
			@users = User.all
			@active_employees = Employee.where(:user_id => current_user.id).count
			@data = monthly_calls
		else
			flash[:error] = "Need to be signed in!"
			redirect_to signin_path
		end	
	end
end
