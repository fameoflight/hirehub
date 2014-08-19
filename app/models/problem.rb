class Problem < ActiveRecord::Base
  belongs_to :user
  has_many :submission
  has_many :collection_problems
  has_many :collections, :through => :collection_problems

  has_many :invite_problem_scores

  attr_accessible :name, :statement, :input, :output, :user_id, :score

  validates :name, :presence => true
  validates :statement, :presence => true
  validates :output, :presence => true
  validates :name, :format => {:with => /^[A-Za-z][A-Za-z0-9 ]+$/, :message => "no special character"}

  validates_numericality_of :score, :only_integer => true
  validates_inclusion_of :score, :in => 1..99, :message => 'should be in range 1 - 99'

  auto_strip_attributes :name, :statement, :output, :nullify => false, :squish => true
end
