# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task_by_id, only: %i[show edit]

  def index
    @tasks = Task.all.sort_task_by(params)
  end

  def new
    @task = Task.new
  end

  def show
  end

  def edit
  end

  def create
    @task = Task.new(permitted_tasks_params)
    if @task.save
      redirect_to root_path, notice: I18n.t('tasks.controller.messages.created')
    else
      render 'new', notice: I18n.t('tasks.controller.messages.failed_to_create') # TODO: fix path, n -> a
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(permitted_tasks_params)
      redirect_to root_path, notice: I18n.t('tasks.controller.messages.edited')
    else
      render 'edit', notice: I18n.t('tasks.controller.messages.failed_to_edited') # TODO: fix path, n -> a
    end
  end

  def destroy
    Task.find(params[:id]).destroy!
    redirect_to root_path, notice: I18n.t('tasks.controller.messages.deleted')
  end

  private

  def permitted_tasks_params
    params.require(:task).permit(
      :title,
      :description,
      :due_date,
    )
  end

  def find_task_by_id
    @task = Task.find(params[:id])
  end
end
