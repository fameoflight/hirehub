class ProcessSubmissionJob < Struct.new( :submission_id , :invite_id, :invite_problem_score_id )

	# Securing your running with system calls.
	# http://stackoverflow.com/questions/5186377/suppressing-system-calls-when-using-gcc-g

	attr_accessor :compile_job

	def perform
		@submission = Submission.find( submission_id )

		if @submission.lang == "text"
			handle_text_submission
		else
			handle_code_submission
		end
		return self
	end

	def compile_only
		@compile_job = CompileJob.perform submission_id
		return self
	end

	def run_sample_only
		@compile_job = CompileJob.perform submission_id
		unless @compile_job.success
			puts "ProcessSubmissionJob: Compile Job Failed"
			return self
		end
		run_job = RunJob.perform_sample( submission_id, @compile_job )
		return self
	end

	def handle_text_submission
		problem = Problem.find( @submission.problem_id )

		if @submission.submission_text.to_s == problem.output
			@submission.update_attributes(:status => ( t 'submission.status.accepted') , :judged => true,  :score => problem.score )
			update_invite_problem_score
		else
			@submission.update_attributes(:status => ( t 'submission.status.wrong_answer' ), :judged => true)
		end
	end

	def handle_code_submission
		@compile_job = CompileJob.perform submission_id
		unless @compile_job.success
			puts "ProcessSubmissionJob: Compile Job Failed"
			return
		end

		run_job = RunJob.perform( submission_id, @compile_job )
		update_invite_problem_score
	end

	def update_invite_problem_score
		invite = Invite.find( invite_id )
		invite_problem_score = InviteProblemScore.find( invite_problem_score_id )

		#update only when the score is greater than the current score
		if @submission.score > invite_problem_score.score
			invite.score = @submission.score
			invite_problem_score.score = @submission.score
			invite_problem_score.save
			invite.save
		end
	end
	
	def t( str )
		I18n.t str
	end 

end