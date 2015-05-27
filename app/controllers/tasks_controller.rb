class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :send_to_process]

  def index
    @q = Task.ransack(params[:q])
    @tasks = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_to_process
    @task.send_to_process
    redirect_to @task
  end

  private

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:data_type, :input, :input_from, :url, :text, :url_type)
    end
end
