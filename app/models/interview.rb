class Interview < ActiveRecord::Base
  belongs_to :user

  attr_accessible :candidate_email, :candidate_id, :candidate_name, :end_time, :instruction, :start_time, :timezone, :url_hash, :user_id

  attr_accessible :start_time_date, :start_time_time, :end_time_date, :end_time_time

  validates :candidate_name, :presence => true
  validates :candidate_email, :presence => true
  auto_strip_attributes :candidate_name, :candidate_email

  def start_time_date
    self.start_time ||= Time.now
    self.start_time.strftime('%d/%m/%Y')
  end

  def start_time_time
    self.start_time ||= Time.now
    self.start_time.strftime('%I:%M %p')
  end

  def start_time_date=(d)
    d = Time.zone.parse(d).getutc
    original = start_time || Time.now
    self.start_time = DateTime.new(d.year, d.month, d.day,
                                   original.hour, original.min, original.sec)
  end

  def start_time_time=(d)
    d = Time.zone.parse(d).getutc
    original = start_time || Time.now
    self.start_time = DateTime.new(original.year, original.month, original.day,
                                   d.hour, d.min, d.sec)
  end

  def candidate
    return User.find_by_id(self.candidate_id)
  end

end
