module EmployeesHelper
	def employee_religion(id)
		Religion.where(:id => id).first.religion_name.capitalize
	end

	## This method calculates the performance values for a specific employee
	def employee_performance(employee)
		#Check if there is any call data associated with this employee
		if all_calls.where(:employee_id => employee.id).any?

			## Array holding all calls handled by this employee
			calls_by_this_employee = all_calls.where(:employee_id => employee.id)

	    ## Calls report for this employee
	    @calls_report = call_sorter(calls_by_this_employee.limit(100))

			## Total number of calls handled by this employee
	    @call_count = calls_by_this_employee.count

	    ## Number of successful calls (call_status_id = 1)
	    @success_calls = calls_by_this_employee.where(:call_status_id => 1).count

	    ## Percentage of succesful calls
	    @success_percentage = ((@success_calls.to_f/@call_count.to_f)*100).floor
	      
	    ## Calls Per Day
	    @calls_per_day = (@call_count.to_f/total_num_days).floor

    	## Average Call duration
      @average_call_duration = ((calls_by_this_employee.sum(:call_duration)/60)/@call_count).to_s + "mins"
	  else
	  	## Defaults
	  	@calls_report = []
	  	@call_count = "None Recorded"
	  	@success_calls = 0
	  	@success_percentage = 0
	  	@calls_per_day = "None Recorded"
	  	@average_call_duration = "0mins"
  	end 
	end

	## List containing current user's employees
	def current_user_employees
		@cue = current_user.employees
	end

	## The Current User's Total Active Employee Count
	def current_user_active_employees_count
		@cueac = current_user_employees.where( employee_status_id: 1 ).count
	end

	## The Current User's Total Employee count
	def current_user_employees_count
		@cuec = current_user_employees.count
	end


	def convert_to_mins(secs)
		secs / 60
	end
end
