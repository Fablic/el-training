class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    begin
      @task = Task.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: e, status: :not_found
    end
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      render :show, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  rescue => e
    render json: e, status: :unprocessable_entity
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      render :show
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])

    if @task.destroy
      head :no_content
    else
      head :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    head :unprocessable_entity
  end

  private
  def task_params
    params.fetch(:task, {}).permit([:name, :description])
  end
end
