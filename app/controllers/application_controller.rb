class ApplicationController < ActionController::Base
  include ApplicationHelper
	before_action :authenticate_user!
	before_action :configure_permitted_parameters, if: :devise_controller?
	layout :layout_by_resource

	def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:emailname, :username])
  end
end
