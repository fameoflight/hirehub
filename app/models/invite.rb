class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection

  has_many :invite_problem_scores

  has_many :invite_submissions
  has_many :submissions, :through => :invite_submissions, :order => "created_at DESC"

  validates :collection_id, :presence => true
  validates :candidate_name, :presence => true
  validates :candidate_email, :presence => true
  validates_uniqueness_of :url_hash

  auto_strip_attributes :candidate_name, :candidate_email, :squish => true

  attr_accessible :user_id, :collection_id, :candidate_name, :candidate_email, :url_hash, :start_time, :score, :user, :collection, :agree, :candidate_id, :instruction, :user_finish, :finish_time

  def finished?
    if self.agree
      if time_left <= 0
        return true
      end
    end
    return false
  end

  def time_left
    if self.user_finish
      return 0
    end
    if self.start_time.nil?
      return -1
    end

    time_duration = self.collection.duration
    time_duration = time_duration.hour * 3600 + time_duration.min * 60 + time_duration.sec
    time_left = self.start_time + time_duration - Time.now
    return [time_left.to_i, 0].max
  end

  def candidate
    return User.find_by_id(self.candidate_id)
  end

  def has_relation(user_id)
    if self.candidate_id == user_id
      return 1
    end
    if self.user_id == user_id
      return 2
    end
    return 0
  end
end
