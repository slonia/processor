class Task < ActiveRecord::Base
  mount_uploader :input, TextUploader

  def send_to_process
    TomitaWorker.perform_async(self.id)
  end

  def process

  end
end
