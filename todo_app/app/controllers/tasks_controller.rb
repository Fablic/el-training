class TasksController < ApplicationController

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  private
  def task_params
    params.require(:task).permit(:title, :description, :deadline, :status, :priority)
  end
end
