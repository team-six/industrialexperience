class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_no_cache

  include SessionHelper
  include ApplicationHelper
  
	private  
		def current_user  
			@current_user ||= User.find_by_auth_token(  
			cookies[:auth_token]) if cookies[:auth_token]  
		end  
	helper_method :current_user 

  
  def set_no_cache
	  response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
	  response.headers["Pragma"] = "no-cache"
	  response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
