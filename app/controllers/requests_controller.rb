class RequestsController < ApplicationController
  def new
    @request = Request.new
  end

  def create
    @request = Request.new(params[:request])
    @request.request = request
    if @request.deliver
      flash[:success] = "We have received your request and will contact you via email with feedback"
      redirect_to signin_path
    else
      flash[:error] = "Invalid email entered, please try again"
      redirect_to signin_path
    end
  end
end
