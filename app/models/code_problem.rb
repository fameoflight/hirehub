class CodeProblem < ActiveRecord::Base
  belongs_to :user
  has_many :collection_code_problems
  has_many :collections, :through => :collection_code_problems

  mount_uploader :input, CodeProblemFilesUploader
  mount_uploader :output, CodeProblemFilesUploader
  mount_uploader :sample_input, CodeProblemFilesUploader
  mount_uploader :sample_output, CodeProblemFilesUploader

  attr_accessible :name, :statement, :input, :output, :score, :user_id, :timeout, :sample_input, :sample_output


  validates :input, :output, :sample_input, :sample_output, :presence => true,
            :file_size => {
                :minimum => 1.bytes.to_i,
                :maximum => 10.megabytes.to_i
            }

  validates :name, :statement, :presence => true
  validates :name, :format => {:with => /^[A-Za-z][A-Za-z0-9 ]+$/, :message => "no special character"}
  validates_numericality_of :score, :only_integer => true
  validates_inclusion_of :score, :in => 1..99, :message => 'should be in range 1 - 99'
  validates_numericality_of :timeout, :only_integer => true
  validates_inclusion_of :timeout, :in => 1..30, :message => 'should be in range 1 - 30'

  auto_strip_attributes :name, :statement, :input, :output, :squish => true
end
