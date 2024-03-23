class ApplicationController < ActionController::Base
    before_action :configure_devise_parameters, if: :devise_controller?
  
    def configure_devise_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
      devise_parameter_sanitizer.permit(:account_update, keys: [:firstname, :lastname])
    end

    def check_admin
      unless current_admin
        flash[:alert] = "Vous n'avez pas les droits d'accès nécessaires."
        redirect_back(fallback_location: root_path)
      end
    end

    def not_found!
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end
  