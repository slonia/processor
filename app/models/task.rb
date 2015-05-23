class Task < ActiveRecord::Base
  mount_uploader :input, TextUploader
  mount_uploader :output, TextUploader
  extend Enumerize

  enumerize :data_type, in: [:place, :person, :date]

  after_commit :send_to_process, on: :create
  before_create :set_status


  def send_to_process
    TomitaWorker.perform_async(self.id)
  end

  def process
    from = Rails.root.join('lib', 'parsers', data_type)
    to = Rails.root.join('tmp', 'processing', id.to_s)
    FileUtils.copy_entry(from, to)
    file = Rails.root.join('public').to_s + input.url
    out = File.join(to, 'input.txt')
    FileUtils.copy_entry(file, out)
    to2 = to.to_s.gsub(/ /, '\ ')
    %x[cd #{to2} && tomita config.proto]
    result = to.to_s + '/output.txt'
    self.output = File.open(result)
    self.status = 'processed'
    self.save
    FileUtils.rm_rf(to)
  rescue Exception => e
    self.update_column(:status, "Error: #{e.message || 'Unknown error'}")
    raise
  end

  def input_content
    File.read(Rails.root.to_s + '/public' + self.input.url) if self.input.url
  end

  def output_content
    File.read(Rails.root.to_s + '/public' + self.output.url) if self.output.url
  end

  def set_status
    self.status = 'processing'
  end
end
