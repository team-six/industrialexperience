class UsersController < ApplicationController
  include ApplicationHelper
  include SessionHelper 
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    
    #All users shouldn't be available anywhere in the applicattion
    #restricted_access
    
    if signed_in? && current_user.role_id == 1
      @users = User.where(:role_id => 2)
    else
      restricted_access
    end
  end

  def show
    #All users shouldn't be available anywhere in the applicattion
    #restricted_access
    if signed_in? && current_user.role_id == 1  || signed_in? && current_user.id == @user.id
      @user = User.find(params[:id])
    else
      restricted_access
    end
  end

  def new
    #All users shouldn't be available anywhere in the applicattion
    if signed_in? && current_user.role_id == 1 
      @user = User.new
    else
      restricted_access
    end
  end

  def edit
    if signed_in? && current_user.role_id == 1 || current_user.id == @user.id
    else
      restricted_access
    end
  end
  
  def create
    if signed_in? && current_user.role_id == 1
      @user = User.new(user_params)
      @user.role_id = 2

      respond_to do |format|
        if @user.save
          #if ping('74.125.224.72')
            UserConfirmationMailer.confirmation_mail(@user).deliver
          #else
          #  flash[:notice] = "Mail Couldn't be sent"
          #end
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      restricted_access
    end
  end


  def update
    if signed_in? && current_user.role_id == 1 || current_user.id == set_user.id
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if signed_in? && current_user.role_id == 1 || current_user.id == set_user.id

      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      restricted_access
    end
  end

  def change_password
    
  end

  def ping(host)
    begin
      Timeout.timeout(5) do 
        s = TCPSocket.new(host, 'echo')
        s.close
        return true
      end
    rescue Errno::ECONNREFUSED 
      return true
    rescue Timeout::Error, Errno::ENETUNREACH, Errno::EHOSTUNREACH
      return false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:user_fname, :user_lname, :user_email)
    end
end
