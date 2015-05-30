class Task < ActiveRecord::Base
  extend Enumerize
  default_scope -> {order(created_at: :desc)}

  ALLOWED_TYPES = [:file, :text, :url]
  SITES = {
    tut: 'tut.by',
    wiki: 'ru.wikipedia.org'
  }
  mount_uploader :input, TextUploader
  mount_uploader :output, TextUploader
  mount_uploader :debug_info, TextUploader

  paginates_per 20

  enumerize :data_type, in: [:all, :place, :person, :date]
  enumerize :input_from, in: ALLOWED_TYPES
  enumerize :url_type, in: SITES.keys

  validate :url_for_site

  after_create :send_to_process
  before_create :set_status


  def send_to_process
    if Rails.env.production?
      TomitaWorker.perform_async(self.id)
    else
      self.process
    end
  end

  def process
    name = "process_from_#{input_from}"
    send(name)
  end

  def prepare_html
    content = Nokogiri::HTML(open(url))
    ['head', 'script', 'table','img', 'link'].each do |tag|
      content.css(tag).find_all.map(&:remove)
    end
    tag_id = (url_type == :tut) ? '#article_body' : '#bodyContent'
    content.at_css(tag_id).text
  end

  def process_from_url
    web_text = prepare_html
    name = "tmp/#{Time.now.to_i}.txt"
    file = File.open(name, "w") { |f| f.write(web_text) }
    self.input = File.open(name)
    self.save
    process_from_file
  end

  def process_from_text
    name = "tmp/#{Time.now.to_i}.txt"
    file = File.open(name, "w") { |f| f.write(text) }
    self.input = File.open(name)
    self.save
    process_from_file
  end

  def process_from_file
    from = Rails.root.join('lib', 'parsers', data_type)
    to = Rails.root.join('tmp', 'processing', id.to_s)
    FileUtils.copy_entry(from, to)
    file = Rails.root.join('public').to_s + input.url
    out = File.join(to, 'input.txt')
    FileUtils.copy_entry(file, out)
    to2 = to.to_s.gsub(/ /, '\ ')
    start_time = Time.now.to_f
    %x[cd #{to2} && tomita config.proto]
    end_time = Time.now.to_f
    result = to.to_s + '/output.txt'
    self.output = File.open(result)
    self.status = 'processed'
    self.processing_time = end_time - start_time
    self.debug_info = File.open(result.gsub('output.txt', 'debug.html'))
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

  def debug_content
    File.read(Rails.root.to_s + '/public' + self.debug_info.url).html_safe if self.debug_info.url
  end

  def set_status
    self.status = 'processing'
  end

  def translated_status
    status.match('process') ? I18n.t("status.#{status}") : status
  end

  def human_time
    self.processing_time ? "#{self.processing_time.round(3)} сек." : ''
  end

  def url_for_site
    if input_from == :url
      errors.add(:url, 'Адрес не соответствует выбранному сайту') unless url.match(SITES[url_type.to_sym])
    end
  end
end
