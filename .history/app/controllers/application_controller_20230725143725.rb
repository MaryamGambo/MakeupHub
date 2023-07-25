class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :primary_address, :primary_city, :primary_postal_code, :primary_province_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :primary_address, :alt_address, :primary_city, :alt_city, :primary_postal_code, :alt_postal_code, :primary_province_id, :alt_province_id])
  end

end
