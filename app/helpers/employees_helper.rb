module EmployeesHelper
	def employee_religion(id)
		Religion.where(:id => id).first.religion_name.capitalize
	end

	## This method calculates the performance values for a specific employee
	def employee_performance(employee)
		#Check if there is any call data associated with this employee
		if all_calls.where(:employee_id => employee.id).any?

			## Array holding all calls handled by this employee
			calls_by_this_employee = all_calls.where("employee_id =?", employee.id)

	    ## Calls report for this employee
	    @calls_report = call_sorter(calls_by_this_employee.limit(100))

			## Total number of calls handled by this employee
	    @call_count = calls_by_this_employee.count

	    ## Number of successful calls (call_status_id = 1)
	    @success_calls = calls_by_this_employee.where("call_status_id = ?", 1).count

	    ## Percentage of succesful calls
	    @success_percentage = ((@success_calls.to_f/@call_count.to_f)*100).floor
	      
	    ## Calls Per Day
	    @calls_per_day = (@call_count.to_f/total_num_days).floor

    	## Average Call duration
      @average_call_duration = ((calls_by_this_employee.sum("call_duration")/60)/@call_count).to_s + "mins"
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
		@cueac = current_user_employees.active.count
	end

	## The Current User's Total Employee count
	def current_user_employees_count
		@cuec = current_user_employees.count
	end


	def convert_to_mins(secs)
		secs / 60
	end

	#==================================================================
	##	Comparisons
	#==================================================================

	def employee_call_count_comparison(employee)
		if employee.calls.any?
			## Total number of Calls
			call_count = all_calls.count
			## Total number of calls handled by this employee
			curr_employee_call_count = all_calls.where(:employee_id => employee.id).count
			## Total number of employees
			employee_count = all_employees.count
			## Average expected call count/per employee
			avg = (call_count/employee_count).to_f
			## Difference between expected call count and current employee count
			diff = avg - curr_employee_call_count
			
			if diff > 0
				((diff/avg)*100).round(1).to_s + "% LT Avg " + "( " + avg.to_s + " )"
			elsif diff < 0
				(((diff*-1)/avg*100)).round(1).to_s + "% HT Avg " + "( " + avg.to_s + " )"
			else
				"= Avg " + "( " + avg.to_s + " )"
			end	
		else
			0
		end
	end

	def employee_success_comparison(employee)
		if employee.calls.any?
			emp_total_calls = all_calls.where(employee_id: employee.id)
			emp_total_calls_count = all_calls.where(employee_id: employee.id).count
			emp_success_calls = emp_total_calls.where(call_status_id: 1).count

			emp_success_percentage = ((emp_success_calls.to_f/emp_total_calls_count.to_f)*100).floor

			diff = success_percentage - emp_success_percentage
			diff_percentage = (success_percentage.to_f * (diff.to_f/100)).round(1)

			
			if diff_percentage > 0
				(diff_percentage).to_s + "% LT Avg " + "( " + success_percentage.to_s + "% )"
			elsif diff_percentage < 0
				(diff_percentage*-1).to_s + "% HT Avg " + "( " + success_percentage.to_s + "% )"
			else
				"= Avg " + "( " + success_percentage.to_s + "% )"
			end	
		else
			0
		end
	end

	def employee_avg_calls_comparison(employee)
		if employee.calls.any?
			emp_total_calls = all_calls.where(employee_id: employee.id).count
			emp_calls_per_day = (emp_total_calls.to_f/total_num_days.to_f)

			avg_calls_per_day_per_employee = ((all_calls.count / total_num_days)/all_employees.count).round(1)

			diff = (avg_calls_per_day_per_employee - emp_calls_per_day).round(1)

			percent_diff = ((diff / avg_calls_per_day_per_employee)*100).round(1)

			if percent_diff < 0
				(percent_diff*-1).to_s + "% HT Avg " + "( " + avg_calls_per_day_per_employee.to_s + " )"
			elsif percent_diff > 0
				percent_diff.to_s + "% LT Avg " + "( " + avg_calls_per_day_per_employee.to_s + " )"
			else
				"= Avg " + "( " + avg_calls_per_day_per_employee.to_s + " )"
			end	
		else
			0
		end
	end

	def employee_avg_time_comparison(employee)
		if employee.calls.any?
			employee_avg_duration = (all_calls.where(employee_id: employee.id).average(:call_duration)/60).round(1)
			diff = avg_call_duration - employee_avg_duration

			percent_diff = ((diff/avg_call_duration)*100).round(1)

			if percent_diff < 0
				(percent_diff*-1).to_s + "% HT Avg " + "( " + avg_call_duration.to_s + " )" 
			elsif percent_diff > 0
				percent_diff.to_s + "% LT Avg " + "( " + avg_call_duration.to_s + " )" 
			else
				"= Avg " + "( " + avg_call_duration.to_s + " )" 
			end
		else
			0
		end
	end
end
