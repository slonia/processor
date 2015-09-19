class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    Rails.logger.info '!!!!!!!!!!!!'
    Rails.logger.debug @email.to_s
  end
end
