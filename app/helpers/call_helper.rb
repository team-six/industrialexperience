module CallHelper

	#==================================================================
	##	Service Desk GSC Calculations
	#==================================================================

	def avg_call_wait
		total_call_wait = 0
		if all_calls.any?
			#total_call_wait = all_calls.sum("call_wait_period")
			all_calls.average("call_wait_period").floor
		else
			0
		end
		 #avg_call_wait = (total_call_wait / all_calls.count)
	end 

	def avg_call_duration
		all_calls.any? ? ((all_calls.average("call_duration")).floor) : 0 
	end

	def arrival_rate
		rate = calls_per_day.to_f / 86400.to_f 
	end

	# Average Speed Of Answer
	def asa
		((erlang_C_formula*traffic_intensity)/(all_employees.active.count*(1-agent_occupancy)))
	end

	def traffic_intensity
		traffic_inten = 0
		if all_calls.any?
			#traffic_inten = avg_call_wait * avg_call_duration
			traffic_inten = arrival_rate.to_f * avg_call_duration.to_f
		end
	end

	def agent_occupancy
		#number_of_employees = 0
	  #agent_occup = 0
		#if all_calls.any?
		#print "Enter number of available employees: "
		#number_of_employees =  val #gets
	  # end
		#agent_occup = (number_of_employees.to_f / traffic_intensity.to_f).round(2)
		if all_calls.any?
			traffic_intensity.to_f / all_employees.active.count
		else
			0
		end
	end

	def probability_of_call_wait
		erlang_C_formula * 100
	end

	def factorial (num)
		if (num <= 1)
			1
		else
			num * factorial(num - 1)
		end
	end

	def target_answer_time
		current_user.settings.target_answer_time
	end

	def service_level
		if all_calls.any?
	    e = 2.7182818284590452353602874713526624977572
	    m = all_employees.active.count
	    u = traffic_intensity

	    target_answer_time = current_user.settings.target_answer_time

	    ((1-probability_of_call_wait) * e**(-(m-u)*(target_answer_time.to_f/avg_call_duration.to_f)))
	  else
	  	0
	  end
	end

	def current_service_level
		val = (service_level*100).round(2)

		if val < 0
			0
		else
			val
		end
		
	end

	## Report for the Current Service Level
	def csl_report

	end

	def carpenter
    e =  2.7182818284590452353602874713526624977572
    m = 0
    sl_enter = current_user.settings.service_level
    sl = service_level
    u = traffic_intensity

    while sl != sl_enter do
  	  sl = 1 - (probability_of_call_wait* e**(-(m-u)*(target_answer_time/avg_call_duration)))
    	m += 1
    end

    m
end

	def capacity
    e =  2.7182818284590452353602874713526624977572
    m = 0
    u = traffic_intensity
    sl_enter = current_user.settings.service_level
    capa = 0 #= 1-(probability_of_call_wait * e**(-(m-u)*(target_answer_time/avg_call_duration)))
    
    #while  capa < sl_enter do
    for m in  0..13
  	 	capa = (probability_of_call_wait * e**(-(m-u)*(target_answer_time/avg_call_duration)))
    	m = m + 1
    end
    m
	end

	def capa
		if all_calls.any?
	    e =  2.7182818284590452353602874713526624977572
	    m = 0
	    target_answer_time = current_user.settings.target_answer_time
	    sl_enter = current_user.settings.service_level
	    u = traffic_intensity
	    sl = -100000

	    while sl <= (sl_enter - 100) do
	      sl = 1 - (66.67 * e**(-(m-u)*(target_answer_time.to_f/avg_call_duration.to_f)))
	      m = m + 0.1
	    end
	    m
	  else
	  	0
	  end
	end

	def tat
		target_answer_time.to_f/avg_call_duration.to_f
	end


	def summation(k=0)
    sum_a = 0
    for k in 0..all_employees.active.count-1
      sum_a = (traffic_intensity**k)/factorial(k) + sum_a
    end
    sum_a
	end

	def erlang_C_formula
		if all_calls.any?
		  erlang = 0
		  r = ((traffic_intensity**all_employees.active.count) / factorial(all_employees.active.count))
		  erlang =  r/(r + (1 - (agent_occupancy / 100))* summation)
		else
			0
		end
	end

end
