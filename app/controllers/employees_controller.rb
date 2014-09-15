class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  #include SessionHelper
  #include ApplicationHelper

  # GET /employees
  # GET /employees.json
  def index
    if signed_in? && current_user.role_id == 2

      # Search Results
      if params[:search]
        search_query = params[:search]
        #@employees = all_employees.search(params[:search]).sort { |a,b| a.employee_lname <=> b.employee_lname }
        @employees = all_employees.search(params[:search]).sort { |a,b| 
            [a.employee_status_id, a.employee_lname ]<=>
            [b.employee_status_id, b.employee_lname]
          }.paginate(:page => params[:page], :per_page => 15)
      else
        @employees = all_employees.sort { |a,b| 
            [a.employee_status_id, a.employee_lname ]<=>
            [b.employee_status_id, b.employee_lname]
          }.paginate(:page => params[:page], :per_page => 15)
      end
    else
      restricted_access
    end

    
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    if signed_in? && current_user.role_id == 2 && set_employee.user_id == current_user.id
      # Get appropriate Employee
      @employee = Employee.find(params[:id])
      # Get Employee's religion
      @religion = Religion.where(:id => @employee.religion_id).first.religion_name.capitalize
    else
      flash[:error] = "You don't have an employee with that ID"
      redirect_to employees_path 
    end
  end

  def import
    if signed_in? && current_user.role_id == 2
      begin
        Employee.import(params[:file])
        flash[:success] = "Employees Imported Successfully"
        redirect_to employees_path
      rescue
        flash[:error] = "Invalid CSV File"

        redirect_to employee_import_path
      end
    else
      restricted_access
    end
  end

  # delete this if not needed
  #def employee_import

  #end

  def search
    @employee = Employee.search(params[:search])
  end

  # GET /employees/new
  def new
    if signed_in? && current_user.role_id == 2
      @employee = Employee.new
      @religions = Religion.all
      @current_user_id = current_user.id
    else
      restricted_access
    end
  end

  # GET /employees/1/edit
  def edit
    if signed_in? && current_user.role_id == 2 && set_employee.user_id == current_user.id
      @religions = Religion.all
    else
      flash[:error] = "You don't have an emplyee with that ID"
      redirect_to employees_path 
    end
  end

  # POST /employees
  # POST /employees.json
  def create
    if signed_in? && current_user.role_id == 2
      @employee = Employee.new(employee_params)
      @religions = Religion.all

      respond_to do |format|
        if @employee.save
          emp_name = @employee.full_name
          format.html { redirect_to @employee, notice: emp_name + ' was successfully created.' }
          format.json { render action: 'show', status: :created, location: @employee }
        else
          format.html { render action: 'new' }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      end
    else
      restricted_access
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    @religions = Religion.all
    if signed_in? && current_user.role_id == 2 && set_employee.user_id == current_user.id
      respond_to do |format|
        if @employee.update(employee_params)
          format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end
      end
    else
      restricted_access
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:employee_fname, :employee_lname,:employee_left, :employee_started, :employee_contact_num, :employee_email, :religion_id, :user_id)
    end
end
