module ApplicationHelper

	def bodytag_id
	  a = controller.class.to_s.underscore.gsub(/_controller$/, '')
	  b = controller.action_name.underscore
	  "#{a}-#{b}".gsub(/_/, '-')
	end
	
	#==================================================================
	##	Sorting Calls
	#==================================================================
	def call_sorter(call_array)
		sorted_array = call_array.sort do |a,b| 
      [ b.call_starttime.strftime("%m").to_i, 
        b.call_starttime.strftime("%d").to_i,
        a.call_starttime
      ] <=> 
      [ a.call_starttime.strftime("%m").to_i, 
        a.call_starttime.strftime("%d").to_i,
        b.call_starttime 
      ]
    end 
	end

	#==================================================================
	##	Security
	#==================================================================

	## Catch restricted pages
	def restricted_access
		#render "error_pages/404"
		flash[:error] = "Please Sign In To View Requested Pages"
		redirect_to signin_path
	end


	#==================================================================
	##	Totals
	#==================================================================
	##  For use in calculations,display and anything else
	##  All values are related to the user that's currently logged in

	def all_employees
		current_user.employees
	end

	def all_calls
		current_user.calls
	end


	#==================================================================
	##	Averages
	#==================================================================


	## Total number of days from first call to last call
	def total_num_days
		if all_calls.any?
			recent_date = all_calls.maximum("call_starttime")
			oldest_date = all_calls.minimum("call_starttime")
			total_days = ((recent_date - oldest_date)/86400).floor
		end
		return total_days.to_f
	end

	## Average number of calls per day
	def calls_per_day
		if all_calls.any?			
			(all_calls.count / total_num_days).floor.to_s + "/day"
		else
			"None Recorded"
		end
	end

	## Calculate Call success percentage as a whole
	def success_percentage
		if all_calls.any?
			success_calls = all_calls.where(:call_status_id => 1).count
			#total_calls = Call.all.count
			@percentage = ((success_calls.to_f / all_calls.count.to_f)*100).floor
		else
			@percentage = 0
		end
	end

	def avg_call_duration
		all_calls.any? ? ((all_calls.average(:call_duration)/60).floor) : 0 
	end

	def avg_call_duration_refactor
		all_calls.any? ? ((all_calls.average(:call_duration)/60).floor).to_s + "mins" :  "0 mins"
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

	#==================================================================
	##	Navigation
	#==================================================================

	## This method creates a link with a class "current"
  ## Useful to show which page is active using CSS
	def nav_link(link_text, link_path)
  		class_name = current_page?(link_path) ? 'current' : ''

  		content_tag(:li, :class => class_name) do
    		link_to (raw("<i class='fa fa-angle-right'></i> ") + link_text), link_path
  		end
	end


	def avg_call_wait
		total_call_wait = 0
		if all_calls.any?
			total_call_wait = all_calls.sum(:call_wait_period)
		end
		 avg_call_wait = (total_call_wait / all_calls.count)/60
	end 

	def traffic_intensity
		traffic_inten =0
		if all_calls.any?
			traffic_inten = avg_call_wait * avg_call_duration
		end
	end

	def agent_occupancy(val)
		#number_of_employees = 0
	  #agent_occup = 0
		if all_calls.any?
		#print "Enter number of available employees: "
		number_of_employees =  val #gets
	   end
		agent_occup = (number_of_employees.to_f / traffic_intensity.to_f).round(2)
	end

	def probability_of_call_wait(erlang_val)
		erlang_val * 100
	end

	def factorial (number_of_employees)
		if (number_of_employees <= 1)
			1
		else
			number_of_employees * factorial(number_of_employees - 1)
		end
	end


	def summation(k, number_of_employees, t_i)
      sum_a = 0
      for k in 0..number_of_employees-1
        sum_a = (t_i**k)/factorial(k) + sum_a
      end
     sum_a
	end

	def erlang_C_formular(traffic_inten, number_of_employees, agent_occup,sum_a)
	    erlang = 0
	    r = ((traffic_inten**number_of_employees) / factorial(number_of_employees))
	    erlang =  r/(r + (1 - (agent_occup / 100))* sum_a)
	end


#==================================================================
##	Graphs
#==================================================================

	def monthly_calls
		data = []
		for x in 1..12 do		
			data << all_calls.where("extract(month from call_starttime) = ?", x).count
		end
		# Return Data Set
		data
	end

	def graph_monthly_traffic_intensity
		if all_calls.any?
			all_arrs = []
			traff = []
			month_calls = []
			q = 0

			cd = 0

			for x in 1..12 do
				month_calls = all_calls.where("extract(month from call_starttime) = ?", x)
				all_arrs << month_calls
				#all_arrs << ((month_calls.average(:call_duration))/60).floor
			end

			all_arrs.each do |q|
				cd = q.average(:call_duration)
				cw = q.average(:call_wait_period)

				val = (cd*cw).floor

				traff << val
			end
		else
			traff = []
		end

		traff
	end
end
