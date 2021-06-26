class SessionsController < ApplicationController
  before_action :logged_in_user, only: [:destroy]

  def new
    redirect_to root_path , notice: "You are already logged in." if user_logged_in?
  end

  # post method for login
  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      message = 'Something went wrong! Make sure email and password are correct'
      redirect_to login_path, notice: message
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
