class InviteProblemScore < ActiveRecord::Base
  belongs_to :invite
  belongs_to :problem

  attr_accessible :invite_id, :problem_id, :score, :problem_type
end
