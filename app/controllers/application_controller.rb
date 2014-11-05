class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise: Do not show any page except log in if not logged in
  before_action :authenticate_user!

  layout :layout_by_resource

  protected
  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end
end
