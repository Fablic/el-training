class ApplicationController < ActionController::Base

  rescue_from StandardError, with: :render500
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :render404


  def render404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.message}" if exception
    render 'errors/404', status: 404
  end

  def render500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render 'errors/500', status: 500
  end
end
