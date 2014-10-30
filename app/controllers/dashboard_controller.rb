class DashboardController < ApplicationController

	def index
		if signed_in? && current_user.role_id == 2
			@users = User.all
			@active_employees = Employee.where(:user_id => current_user.id).count
			@graph_data = monthly_calls
			
			gon.graph_data = @graph_data
			gon.graph_mti = graph_monthly_traffic_intensity

			gon.graph_success = graph_call_success
			gon.graph_unsuccessful = graph_call_unsuccessful
		else
			flash[:error] = "Need to be signed in!"
			redirect_to signin_path
		end	
	end
end
