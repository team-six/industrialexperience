class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end


    def edit
session[:return_to] ||= request.referer
        end
  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash[:success] = "Thank you for your message. We will contact you soon!"
      redirect_to signin_path
    else
      flash[:error] = "Invalid email entered, please try again"
      redirect_to signin_path
    end
  end
end
