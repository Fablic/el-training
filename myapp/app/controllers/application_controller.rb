# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandle

  before_action :verify_authenticity_token
  before_action :set_locale

  helper_method :current_user
  include ErrorHandle

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_user
    @current_user = User.first
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render_500
    render 'errors/error_500', status: :internal_server_error
  end

  def render_404
    render 'errors/error_404', status: :not_found
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : :en
  end
end
