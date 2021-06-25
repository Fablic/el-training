class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = Task.where(deleted_at: nil)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    task_params = params[:task].permit(:task_name, :priority_id, :label, :limit_date, :detail)
    task_params["status_id"] = 1 # 「未着手」固定
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "タスクを作成しました。" }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    task_params = params[:task].permit(:task_name, :status_id, :priority_id, :label, :limit_date, :detail)
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "タスクを更新しました。" }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # 論理削除
  def destroy
    now = DateTime.now
    @task.update(deleted_at: now)
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスクを削除しました。" }
      format.json { head :no_content }
    end
  end

  private
    # 共通処理
    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.fetch(:task, {})
    end
end
