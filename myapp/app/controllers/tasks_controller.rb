class TasksController < ApplicationController
  before_action  :valid_task, only: [:create, :update]
  before_action  :valid_id, only: [:edit, :update, :destroy]
  before_action  :valid_status, only: [:index]

  def index
    if @param_status.nil?
      @tasks = Task.all
    else
      @tasks = Task.where(status: @param_status)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(@param_task)

    @task.save!
    flash[:success] = '登録されました'
    redirect_to tasks_url
  rescue => e
    logger.error e
    flash[:danger] = '登録に失敗しました'
    render :new
  end

  def edit
    @task = Task.find(@param_id)
  end

  def update
    @task = Task.find(@param_id)

    @task.update!(@param_task)
    flash[:success] = '更新されました'
    redirect_to tasks_url
  rescue => e
    logger.error e
    flash[:danger] = '更新に失敗しました'
    render :edit
  end

  def destroy
    @task = Task.find(@param_id)
    @task.destroy!
    flash[:success] = '削除しました'
    redirect_to tasks_url
  rescue => e
    logger.error e
    flash[:danger] = '削除に失敗しました'
    redirect_to tasks_url
  end

  private

  def valid_id
    @param_id = params[:id].to_i

    if @param_id <= 0
      logger.error("値が不正:" + params[:id])
      flash[:danger] = '値が不正です'
      render_404
    end
  end

  def valid_task
    @param_task = params.require(:task).permit(:title, :description, :status)
    if @param_task[:title].blank?
      flash[:danger] = 'タイトルは必須入力です'
      redirect_back(fallback_location: root_path)
    end
  end

  def valid_status
    if params[:status].nil?
      @param_status = nil
      return
    end

    @param_status = params[:status].to_i
    
    if @param_status > Task.statuses[:completed]
      flash[:danger] = '値が不正です'
      render_404
    end
  end
end
