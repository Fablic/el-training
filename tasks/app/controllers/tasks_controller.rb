class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = Task.without_deleted.search_task_name(params[:keyword]).search_status(params[:statuses]).sort_task("#{sort_column} #{sort_direction}")
    @status_list = MasterTaskStatus.all
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    create_params = task_params.merge(status_id: MasterTaskStatus::NOT_STARTED)
    @task = Task.new(create_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'タスクを作成しました。' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'タスクを更新しました。' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # 論理削除
  def destroy
    now = Time.current
    @task.update(deleted_at: now)
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'タスクを削除しました。' }
      format.json { head :no_content }
    end
  end

  private

  # 共通処理
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :status_id, :priority_id, :label, :limit_date, :detail)
  end

  def sort_direction
    params[:direction].in?(%w[asc desc]) ? params[:direction] : 'desc'
  end

  def sort_column
    params[:sort].in?(Task.column_names) ? params[:sort] : 'created_at'
  end
end
