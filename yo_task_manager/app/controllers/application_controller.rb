# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    locale = (params[:locale] if I18n.available_locales.include? params[:locale]&.to_sym) || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def user_is_logged_in
    if !session[:user_id]
      redirect_to login_path
    end
  end
end
