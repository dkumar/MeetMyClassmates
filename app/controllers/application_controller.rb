class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise: Do not show any page except log in if not logged in
  before_action :authenticate_user!

  layout :layout_by_resource

  def get_time(year, month, day, hours, minute, tag)
    if tag == "P.M." && hours != "12"
      num_hours = hours.to_i + 12
      hours = num_hours.to_s
    elsif tag == "P.M." && hours == "12"
      hours = "12"
    elsif tag == "A.M." && hours == "12"
      hours = "23"
      minute = "59"
    end

    Time.utc(year, month, day, hours, minute, 0)
  end

  protected
  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
