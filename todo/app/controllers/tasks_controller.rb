# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @tasks =
      if params[:order_by].present?
        getting_tasks(@project)
      else
        @project.tasks.order(created_at: :desc)
      end
  end

  def show
  end

  def new
    @users = User.all
    @task = Task.new
    @project = Project.find(params[:project_id])
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '作成')
    else
      flash[:error] = @task.errors.full_messages.join(',')
      redirect_to new_task_path(project_id: task_params[:project_id])
    end
  end

  def edit
    @users = User.all
    @project = @task.project
  end

  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '更新')
      redirect_to @task
    else
      flash[:error] = @task.errors.full_messages.join(',')
      redirect_to edit_task_path(project_id: task_params[:project_id])
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '削除')
      redirect_to tasks_path(project_id: @task.project_id)
    else
      flash[:error] = I18n.t('flash.failed', model: 'タスク', action: '削除')
      render :index
    end
  end

  def getting_tasks(project)
    pjid = project.id
    Task.name_search(params[:task_name_input], pjid)
    .sta_search(params[:status_search], pjid)
    .pri_search(params[:priority_search], pjid)
    .order_by(params[:order_by], pjid)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at, :status)
  end
end
