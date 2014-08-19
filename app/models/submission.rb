class Submission < ActiveRecord::Base
  belongs_to :user

  has_many :invite_submissions

  attr_accessible :user_id, :problem_id, :submission_text, :judged, :score, :lang, :problem_type, :status, :compiler_output, :execution_time, :submittable_id, :submittable_type, :run_output

  auto_strip_attributes :submission_text
  auto_strip_attributes :lang, :squish => true

  validates :lang, :presence => true
  validates :submission_text, :presence => true

  def self.lang
    return [['c', "C"], ['cpp', "C++"], ['ruby', "Ruby"],
            ['python', "Python"], ['java', 'Java'], ['csharp', 'C# (Mono)'], ['scala', 'Scala']]
  end

  def humanize_lang
    Submission.lang.each do |ln|
      if self.lang == ln.first
        return ln.second
      end
    end

    return self.lang.humanize
  end


  def problem_name
    if problem_type == 'text'
      return Problem.find_by_id(self.problem_id).name
    end
    if problem_type == 'code'
      return CodeProblem.find_by_id(self.problem_id).name
    end
    return 'Unknown Problem'
  end

  def problem_output
    if problem_type == 'text'
      return Problem.find_by_id(self.problem_id).output
    end
    return SecureRandom.hex(32)
  end

  def problem_output_sample
    if problem_type == 'code'
      file_name = CodeProblem.find_by_id(self.problem_id).sample_output.to_s
      if file_name.length == 0
        return 'No Samples for this problem'
      end
      sample_output_text = File.open(file_name, 'rb').read
      return sample_output_text
    end

    return SecureRandom.hex(32)
  end


  def problem_score
    if problem_type == 'text'
      return Problem.find_by_id(self.problem_id).score
    end
    return 0
  end
end
