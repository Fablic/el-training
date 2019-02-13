# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, with: :render_422

  def render_404
    render file: Rails.root.join('public', '404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  def render_422
    render file: Rails.root.join('public', '422.html'), status: 422, layout: false, content_type: 'text/html'
  end

  def render_500
    render file: Rails.root.join('public', '500.html'), status: 500, layout: false, content_type: 'text/html'
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path, flash: { danger: I18n.t('flash.login.required') } unless current_user
  end
end
