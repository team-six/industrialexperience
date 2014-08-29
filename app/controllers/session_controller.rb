class SessionController < ApplicationController
	include SessionHelper
  include ApplicationHelper

	def new

    if signed_in?
      if current_user.role_id == 2
        flash[:notice] = "Already signed in"
        redirect_to dashboard_index_path
      elsif current_user.role_id== 1
        flash[:notice] = "Already signed in"
        redirect_to admin_users_path 
      end        
    end

  end

  def create
  	user = User.find_by_user_email(params[:session][:email].downcase)
  	@user = user

    if user && user.authenticate(params[:session][:password])
        user.increment_login
    		sign_in user
        

        #User Type determines which interface to load
        if current_user.role_id == 2
      	  redirect_to dashboard_index_path
        elsif current_user.role_id == 1
          redirect_to administration_path
        end
    else
      	flash[:error] = 'Incorrect Email/Password Combination'
      	redirect_to signin_path    
    end
  end

  def destroy
    #Before destroy, save user name for logging out message
    leaving_user = current_user.user_fname.capitalize + " " + current_user.user_lname.capitalize

    sign_out
    flash[:success] = "#{leaving_user} logged out successfully"
    redirect_to signin_path
  end
end
