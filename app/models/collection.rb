class Collection < ActiveRecord::Base
  belongs_to :user

  # has_many :invites
  has_many :collection_problems
  has_many :problems, :through => :collection_problems

  has_many :collection_code_problems
  has_many :code_problems, :through => :collection_code_problems

  accepts_nested_attributes_for :problems, :code_problems
  attr_accessible :name, :user_id, :start_time, :duration, :collection_problems_attributes, :problems, :problem_attributes, :problem_ids, :public,
                  :collection_code_problems_attributes, :code_problems, :code_problem_attributes, :code_problem_ids

  validates :name, :presence => true
  validates :name, :uniqueness => {:case_sensitive => false}
  validates :name, :format => {:with => /^[A-Za-z][A-Za-z0-9 ]+$/, :message => "no special character"}
  validate :ensure_problems

  auto_strip_attributes :name, :squish => true

  def humanize_duration
    hour_s = "#{duration.hour} Hour"

    if duration.hour > 1
      hour_s = hour_s + "s"
    end

    min_s = "#{duration.min} minute"

    if duration.min > 1
      min_s = min_s + "s"
    end

    if duration.hour > 0
      if duration.min > 0
        return hour_s + " and " + min_s
      end
      return hour_s
    end

    return min_s
  end

  def ensure_problems
    total_problems = problems.size + code_problems.size
    if total_problems == 0
      errors.add(:problems, 'No Problem Selected')
      errors.add(:code_problems, 'No Code Problem Selected')
    end
  end

end
