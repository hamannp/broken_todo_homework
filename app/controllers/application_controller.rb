class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(exception)
    flash[:notice] = exception.message
    render file: "#{Rails.root}/public/404.html", layout: true
  end
end
