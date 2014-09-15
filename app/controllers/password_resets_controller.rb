class PasswordResetsController < ApplicationController
  
  def create  
    user = User.find_by_user_email(params[:email])  
    user.send(:send_password_reset) if user  
    redirect_to signin_path, :notice => "Email sent with password reset instructions."  
  end  

  def edit  
    @user = User.find_by_password_reset_token!(params[:id])  
  end  

  def update  
    @user = User.find_by_password_reset_token!(params[:id])  
    if @user.password_reset_sent_at < 2.hours.ago  
      redirect_to new_password_reset_path, :alert => "Password reset has expired."  
    elsif @user.update_attributes(update_params)  
      redirect_to signin_path, :notice => "Password has been reset."  
    else  
      render :edit  
    end  
  end

  private
  def update_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end
