# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_item, only: %i[show edit update destroy]
  before_action :all_users, :selected_user_id, only: %i[index new create edit]

  def index
    @keyword = params[:keyword]
    @status = params[:status]
    @user_id = params[:user_id] || @current_user&.id
    @end_at_sort = params[:end_at]
    @tasks = Task.preload(:user)
                 .preload(labels: :task_labels)
                 .search(@keyword, @status, @user_id, create_sort_query)
                 .page(params[:page])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = I18n.t(:'message.registered_task')
      redirect_to root_path
    else
      flash.now[:error] = I18n.t(:'message.registered_is_failed')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update(task_params)
      flash[:success] = I18n.t(:'message.edited_task')
      redirect_to root_path
    else
      flash.now[:error] = I18n.t(:'message.edited_is_faild')
      render :edit
    end
  end

  def destroy
    if @task.user_id == current_user.id && @task.destroy
      flash[:success] = I18n.t(:'message.deleted_task')
      redirect_to root_path
    else
      flash[:error] = I18n.t(:'message.deleted_is_failed')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def find_item
    @task = Task.find(params[:id])
  end

  def all_users
    @users = User.all
  end

  def selected_user_id
    @selected_user_id = @task&.user_id || @current_user&.id
  end

  def task_params
    params.require(:task).permit(:title, :description, :end_at, :task_status, :user_id, label_ids: [])
  end

  def create_sort_query
    return { end_at: :asc } if params[:end_at] == 'asc'
    return { end_at: :desc } if params[:end_at] == 'desc'

    { created_at: :desc }
  end
end
