class InviteSubmission < ActiveRecord::Base
  belongs_to :invite
  belongs_to :problem
  belongs_to :submission

  attr_accessible :invite_id, :problem_id, :submission_id
end
