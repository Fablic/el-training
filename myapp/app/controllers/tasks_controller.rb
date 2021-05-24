class TasksController < ApplicationController
  PER_PAGE = 10

  def index
    @params = params.permit(:name, :status).select { |_k, v| v.presence }
    @tasks = Task.order(:id).page(params[:page]).per(PER_PAGE)
    @tasks = @tasks.where('name LIKE ?', "%#{ApplicationRecord.sanitize_sql_like(@params[:name])}%") if @params[:name]
    @tasks = @tasks.where(status: @params[:status]) if @params[:status]
  end

  def new
    @task = Task.new(name: '', description: '', priority: :normal, status: :waiting)
  end

  def edit
    # TODO: Check the task exactly belongs to the user.
    @task = Task.find(params.require(:id))
  end

  def create
    task = Task.new(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
    if task.save
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.added') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end

  def update
    # TODO: Check the task exactly belongs to the user.
    task = Task.find(params.require(:id))
    if task.update(params.require(:task).permit(:name, :description, :due_date, :priority, :status))
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.edited') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end

  def destroy
    # TODO: Check the task exactly belongs to the user.
    task = Task.find(params.require(:id))
    if task.destroy
      redirect_to root_path, flash: { info: I18n.t('pages.tasks.flash.deleted') }
    else
      redirect_to root_path, flash: { error: error_message_from(task) }
    end
  end

  private

  def error_message_from(task)
    prefix = ->(v) { "- #{v.first}" } # TODO: It assumes only one validation error exists for each attribute.
    task.errors.messages.values.map(&prefix).join("\n").presence or raise 'This should be called only when validation fails'
  end
end
