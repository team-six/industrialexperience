class CallsController < ApplicationController
  before_action :set_call, only: [:show, :edit, :update, :destroy]
  include ApplicationHelper

  # GET /calls
  # GET /calls.json
  def index
    if signed_in? && current_user.role_id == 2
      # Get last 200 Calls, then sort (Calling sorter method in application_helper.rb)
      @call_list = all_calls.paginate(:page => params[:page], :per_page => 30)
      @calls = call_sorter(@call_list)

      @calls = @calls.paginate(:page => params[:page], :per_page => 20)
    else
      restricted_access
    end
  end

  def import
    if signed_in? && current_user.role_id == 2
      Call.import(params[:file])
      flash[:success] = "Call Data Imported Successfully"
      redirect_to call_path
    else
      restricted_access
    end
  end

  # GET /calls/1
  # GET /calls/1.json
  def show
    if signed_in? && current_user.role_id == 2
    else
      restricted_access
    end
  end

  # GET /calls/new
  def new
    if signed_in? && current_user.role_id == 2
      @call = Call.new
    else
      restricted_access
    end
  end

  # GET /calls/1/edit
  def edit
    if signed_in? && current_user.role_id == 2
    else
      restricted_access
    end
  end

  # POST /calls
  # POST /calls.json
  def create
    if signed_in? && current_user.role_id == 2
      @call = Call.new(call_params)

      respond_to do |format|
        if @call.save
          format.html { redirect_to @call, notice: 'Call was successfully created.' }
          format.json { render action: 'show', status: :created, location: @call }
        else
          format.html { render action: 'new' }
          format.json { render json: @call.errors, status: :unprocessable_entity }
        end
      end
    else
      restricted_access
    end
  end

  # PATCH/PUT /calls/1
  # PATCH/PUT /calls/1.json
  def update
    if signed_in? && current_user.role_id == 2
      respond_to do |format|
        if @call.update(call_params)
          format.html { redirect_to @call, notice: 'Call was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @call.errors, status: :unprocessable_entity }
        end
      end
    else
      restricted_access
    end
  end

  # DELETE /calls/1
  # DELETE /calls/1.json
  def destroy
    @call.destroy
    respond_to do |format|
      format.html { redirect_to calls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_call
      @call = Call.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def call_params
      params.require(:call).permit(:call_startTime, :call_endTime, :call_status, :call_wait_period, :employee_id, :call_status_id, :call_type_id)
    end
end
