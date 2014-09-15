class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash[:notice] = "Thank you for your message. We will contact you soon!"
	  redirect_to signin_path
    else
      flash[:notice] = "Cannot send message."	
	  redirect_to signin_path
    end
  end
end