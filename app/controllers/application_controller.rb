class ApplicationController < ActionController::Base
	include ApplicationHelper
	require './app/services/controllers/filter_service.rb'
	before_action :configure_permitted_parameters, if: :devise_controller?

	rescue_from CanCan::AccessDenied do
	  render json: {code: :forbidden, message: I18n.t("cancan.access_denied")}, status: :forbidden
	end

	protected

	def configure_permitted_parameters
	  devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
	  devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
	end



end
