# frozen_string_literal: true

class SessionsController < ApplicationController
  attr_reader :user

  def index
    # ログインユーザーによって遷移先画面を切り変える
    redirect_to_user_page
  end

  def create
    user = User.find_by(login_id: params[:login_id])
    if user&.authenticate(params[:password])
      log_in(user)
      redirect_to_user_page
    else
      flash[:alert] = I18n.t('sessions.flash.error.create')
      render :index
    end
  end

  def destroy
    log_out
    flash[:notice] = I18n.t('sessions.flash.success.delete')
    redirect_to action: :index
  end

  private

  def redirect_to_user_page
    # ログインしていない場合、他ページにリダイレクトしない
    return unless logged_in?

    flash[:notice] = I18n.t('sessions.flash.success.create')
    return redirect_to admin_users_path if current_user.admin_user?
    redirect_to tasks_path if current_user.general_user?
  end

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
