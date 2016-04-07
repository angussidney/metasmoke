class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action do
    Rack::MiniProfiler.authorize_request if user_signed_in?
  end

  def check_if_smokedetector
    provided_key = params[:key]

    @smoke_detector = SmokeDetector.find_by_access_token(provided_key)

    if @smoke_detector.present?
      return # Authorized
    else
      render :plain => "Go away", :status => 403 and return
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected
    def verify_admin
      if !user_signed_in? || !current_user.is_admin
        raise ActionController::RoutingError.new('Not Found') and return
      end
    end
end
