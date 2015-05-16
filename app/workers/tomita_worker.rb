class TomitaWorker
  include Sidekiq::Worker

  def perform(id)
    @task = Task.find(id)
    @task.process if @task
  end
end
