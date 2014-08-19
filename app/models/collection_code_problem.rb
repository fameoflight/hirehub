class CollectionCodeProblem < ActiveRecord::Base
  belongs_to :collection
  belongs_to :code_problem

  attr_accessible :collection_id, :code_problem_id
end
