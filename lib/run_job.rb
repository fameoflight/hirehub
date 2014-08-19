class RunJob
	attr_accessor :input_file, :output_file, :error_file, :score, :sample, :code_problem, :submission

	def self.perform( submission_id, compile_job )
		run_job = new submission_id , compile_job
		run_job.prepare_dir
		run_job.run

		return run_job
	end

	def self.perform_sample( submission_id , compile_job )
		run_job = new submission_id , compile_job
		run_job.sample = true
		if run_job.code_problem.sample_input.to_s.length == 0
			run_job.submission.update_attributes(:status => ( t 'submission.status.no_sample_input') , :judged => true)
			return run_job
		end
		run_job.prepare_dir
		run_job.run
		return run_job
	end


	def initialize( submission_id, compile_job )
		@sample = false
	 	@submission = Submission.find( submission_id )
	 	@compile_job = compile_job
	 	@code_problem = CodeProblem.find( @submission.problem_id )
	 	if @submission.nil?
	 		raise 'No such submission'
	 	end
	 	@score = 0
	 	@submission.update_attributes(:status => ( t 'submission.status.running' ) )
	end

	def prepare_dir
		@input_file = File.join( @compile_job.solution_dir, 'input.txt' )
		if @sample
			link_or_copy( @code_problem.sample_input.to_s , @input_file )
		else
			link_or_copy( @code_problem.input.to_s , @input_file )
		end

		@output_file = File.join( @compile_job.solution_dir, 'output.txt' )
		@error_file = File.join( @compile_job.solution_dir, 'error.txt' )
	end

	def run
		run_cmd = Settings[@compile_job.lang]['run_cmd']

		if Settings[@compile_job.lang]['type'] == 'compiled'
			run_cmd = run_cmd % [ @compile_job.exe_path , @input_file, @output_file, @error_file , @compile_job.solution_dir ]
		else
			run_cmd = run_cmd % [ @compile_job.code_path , @input_file, @output_file, @error_file ]
		end

		if Rails.env.production?
			run_cmd = Settings[@compile_job.lang]['box_cmd'] % [ run_cmd ]
		end

		puts run_cmd

		sub = Subexec.run run_cmd, :timeout => @code_problem.timeout

		# if update_compiler_output?( @submission.lang )
		# 	compiler_output =  File.open( error_file, "rb").read
		# 	@submission.update_attributes(:compiler_output => compiler_output )
		# end

		if @sample
			run_output = File.open( @output_file , 'rb' ).read
			@submission.update_attributes(:run_output => run_output )
		end

		if sub.exitstatus.nil?
		 	@submission.update_attributes(:status => ( t 'submission.status.time_limit' ) , :judged => true )
		else
			if sub.exitstatus < 2
				output_match = false
				submission_score = 0
				submission_status = ( t 'submission.status.sample_accepted' )
				if @sample
					output_match = cmp_file?( @code_problem.sample_output.to_s , @output_file )
				else
					output_match = cmp_file?( @code_problem.output.to_s , @output_file )
					submission_score =  @code_problem.score
					submission_status = ( t 'submission.status.accepted' )
				end
				if output_match
					@submission.update_attributes(:status => submission_status , :judged => true, :score => submission_score )
					@score = submission_score
				else
					@submission.update_attributes(:status => ( t 'submission.status.wrong_answer' ) , :judged => true)
				end
			else
				if sub.exitstatus.to_i == 139
					status_str = ( t 'submission.status.segmentation_fault')
				else
					status_str = ( t 'submission.status.runtime_error', :exitstatus => sub.exitstatus )
				end
				@submission.update_attributes(:status => status_str , :judged => true )
			end
		end
	end

	def link_or_copy(src, des)
	    begin
	      FileUtils.ln_s(src, des)
	    rescue NotImplementedError
	      FileUtils.cp(src,des)
	    end
	end

	def cmp_file?( filePath1 , filePath2 )
		lines1 = File.readlines filePath1
		lines2 = File.readlines filePath2

		lines1.delete_if { |line| line.strip.length == 0 }

		lines2.delete_if { |line| line.strip.length == 0 }

		return false if lines1.length != lines2.length

		i = 0
		while i < lines1.length
			return false if lines1[i].strip != lines2[i].strip
			i = i + 1
		end

		return true
	end

	def t( str )
		I18n.t str
	end 
end