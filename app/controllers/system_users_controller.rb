class SystemUsersController < ApplicationController
  include SessionHelper
  include ApplicationHelper

  def show
  	@user = SystemUser.find(params[:id]) 
  end

  def create
    @user = SystemUser.new(user_params)

    respond_to do |format|
      if @user.save
        UserConfirmationMailer.confirmation_mail(@user).deliver
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if signed_in? && current_user.role_id == 2
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      restricted_access
    end
  end

  def destroy
    if signed_in? && current_user.role_id == 1
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      restricted_access
    end
  end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:SystemUser).permit(:user_fname, :user_lname, :user_email)
    end
end




