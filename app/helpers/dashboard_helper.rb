module DashboardHelper

	## String representing active employees vs total employees
	def active_employees_display		
		current_user_active_employees_count.to_s + "/" + current_user_employees_count.to_s
	end

	## Capacity Usage percantage
	def active_employees_handle_check
		((current_user_active_employees_count.to_f / current_user_employees_count.to_f)*100).floor.to_s + "% of Capacity "
	end

end
