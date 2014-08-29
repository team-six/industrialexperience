class AdminUsersController < ApplicationController
	include SessionHelper, ApplicationHelper

	def index
	 	if signed_in? && current_user.role_id == 1
	  else
	  	restricted_access
	  end
	end
	
  def show
  	if signed_in? && current_user.role_id == 1
  		@admin_user = User.find(params[:id]) 
  	else
  		restricted_access
  	end
  end
end
