class WelcomeController < ApplicationController
	#include SessionHelper

	def index

		if signed_in?
			if current_user.role_id == 2
				redirect_to dashboard_index_path
			elsif current_user.role_id == 2
				redirect_to administration_path
			end
		end

	end
	
end
