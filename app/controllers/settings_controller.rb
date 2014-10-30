class SettingsController < ApplicationController

  def index
  	if signed_in? && current_user.role_id == 2
	  	@settings = current_user.settings
	  else
	  	restricted_access
	  end
  end

  def show
  	if signed_in? && current_user.role_id == 2
	  	@settings = current_user.settings
	  else
	  	restricted_access
	  end
  end

  def edit
  	if signed_in? && current_user.role_id == 2
	  	@settings = current_user.settings
	  else
	  	restricted_access
	  end
  end

  def update
  	if signed_in? && current_user.role_id == 2
	  	@settings = current_user.settings

	  	respond_to do |format|
        if @settings.update(settings_params)
          format.html { redirect_to settings_path, notice: 'Settings updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'index' }
          format.json { render json: @settings.errors, status: :unprocessable_entity }
        end
      end
	  else
	  	restricted_access
	  end
  end

  private

  def settings_params
     params.require(:settings).permit(:service_level, :expected_success, :expected_employee_success, :target_answer_time)
  end


end

