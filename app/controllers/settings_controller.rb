class SettingsController < ApplicationController
    def update_accessibility_settings
      @setting = current_user.setting 
      @user = current_user
      if @setting.update(setting_params)
        redirect_to user_path(@user), notice: 'Paramètres mis à jour avec succès.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def setting_params
      params.require(:setting).permit(:high_contrast, :opendys)
    end
  end
  