class CollectionProblem < ActiveRecord::Base
  belongs_to :collection
  belongs_to :problem

  attr_accessible :collection_id, :problem_id
end
