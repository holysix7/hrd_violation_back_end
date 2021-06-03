class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include ExceptionHandler

  def timeZone
    timeZone = DateTime.now.in_time_zone('Jakarta')
  end
end
