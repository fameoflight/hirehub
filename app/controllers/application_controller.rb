class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_timezone

  def set_timezone
    Time.zone = current_user.timezone if user_signed_in?
  end

  # Overwriting the sign_out redirect path method

  def after_sign_out_path_for(resource_or_scope)
    feedback_path
  end
end
