class TasksController < ApplicationController
  before_action :logged_in_user

  before_action :logged_in_user

  def index
    @q = current_user.tasks.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @tasks = @q.result.includes(:user).page(params[:page])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.valid?
      @task.save
      redirect_to tasks_url, notice: I18n.t('tasks.flash.create', name: @task.name)
    else
      render :new
    end
  end

  def show
    @task = current_user.tasks.find(params[:id])
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_url, notice: I18n.t('tasks.flash.update', name: @task.name)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: I18n.t('tasks.flash.delete', name: @task.name)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :end_date, :priority, :status)
  end
end
