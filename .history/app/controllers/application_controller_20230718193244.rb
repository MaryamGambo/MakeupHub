class ApplicationController < ActionController::Base
  # ...

  before_action :set_flash_expiry

  private

  def set_flash_expiry
    flash.now[:expiry_time] = Time.current + 5.seconds
  end
end
