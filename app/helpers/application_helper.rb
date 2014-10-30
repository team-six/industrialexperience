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

	def total_calls
		all_calls.count
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

	

	def avg_call_duration_refactor
		all_calls.any? ? ((all_calls.average(:call_duration)/60).floor).to_s + "mins" :  "0 mins"
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

#==================================================================
##	Graphs
#==================================================================

	def current_year
		current_year = Time.now.strftime("%Y").to_i
	end

	def graph_call_success
		@success_calls = all_calls.where( "call_status_id = ?", 1 ).count
	end

	def graph_call_unsuccessful
		@unsuccessful_calls = all_calls.where("call_status_id != ?", 1).count
	end

	def monthly_calls		
		data = []
		calls_filter = all_calls.where("extract(year from call_starttime) = ?", current_year)
		for x in 1..12 do		
			data << calls_filter.where("extract(month from call_starttime) = ?", x).count
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

			calls_filter = all_calls.where("extract(year from call_starttime) = ?", current_year)

			for month in 1..12 do
				month_calls = calls_filter.where("extract(month from call_starttime) = ?", month)
				all_arrs << month_calls
			end

			all_arrs.each do |q|
				if( q.average(:call_duration) != nil || q.average(:call_wait_period) != nil )
					cd = q.average(:call_duration)
					cw = q.average(:call_wait_period)
				else
					cd = cw = 0
				end
				# Intensity equation
				val = (cd*0.2).floor
				val = val
				# Add to traffic hash
				traff << val
			end
		else
			# No data, empty graph
			traff = []
		end

		# Return the Traffic Intensity array
		traff
	end
end
