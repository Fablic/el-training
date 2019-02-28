class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  TASKS_PER_PAGE = 8
  
  def index
    @tasks = Task.all.includes(:user).order(created_at: :desc)
    if params[:title].present?
      @tasks = @tasks.title_search(params[:title]).order(created_at: :desc)
    end
    if params[:status].present?
      @tasks = @tasks.status_search(params[:status]).order(created_at: :desc)
    end
    @tasks = @tasks.page(params[:page]).per(TASKS_PER_PAGE)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task, notice: t('flash.task.created')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.task.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.task.destroyed')
  end

  private
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title, :description, :user_id, :limit, :priority, :status)
    end
end
