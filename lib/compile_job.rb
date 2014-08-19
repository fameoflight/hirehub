class CompileJob

	attr_accessor :submission, :solution_dir, :code_path, :exe_path, :compiler_output, :success, :lang

	def self.perform( submission_id )
	 	job = new submission_id
	 	job.prepare_dir submission_id
	 	job.compile
	 	return job
	 end

	 def initialize( submission_id )
	 	@submission = Submission.find( submission_id )
	 	if @submission.nil?
	 		raise 'No such submission'
	 	end
	 	if @submission.lang == "text"
	 		raise 'Not a code submission'
	 	end

	 	@lang = @submission.lang
	 	@submission.update_attributes(:status => ( t 'submission.status.compiling' ) )
	 end

	 def prepare_dir ( submission_id )
	 	run_dir = Settings['run_dir']
	 	@solution_dir = File.join( run_dir, submission_id.to_s )

	 	if File.exists?(@solution_dir)
	 		puts "#{@solution_dir} already exists, deleting ..."
	 		FileUtils.rm_rf(@solution_dir)
	 	end

	 	FileUtils.mkdir_p @solution_dir
	 	puts "#{@solution_dir} created"
	 	file_ext = Settings[ @lang]['ext']

	 	if file_ext.to_s.length == 0
	 		puts "CompileJob : No Language Extension Found for #{@lang}"
	 		@submission.update_attributes(:status => ( t 'submission.status.system_error' ), :judged => true )
	 		return true
	 	end
	 	@code_path = File.join( @solution_dir, "Solution.#{file_ext}" )
	 	File.open( @code_path , 'w') { |f| f.write(@submission.submission_text) }
	 end

	 def compile
	 	self.success = true
	 	if Settings[ @lang]['type'] == 'compiled'
	 		puts "compiled language"
	 		file_ext2 = Settings[ @lang]['binary_ext']
	 		@exe_path = File.join( @solution_dir, "Solution.#{file_ext2}" )

	 		puts "using #{@exe_path} as exe path"
	 		cmd_line = Settings[ @lang ]['compile_cmd']
	 		cmd_line = cmd_line % [ @code_path , @exe_path, @solution_dir ]
	 		puts "#{cmd_line}"
	 		@compiler_output = %x[#{cmd_line}]

	 		@compiler_output = @compiler_output.to_s.strip

	 		if @compiler_output.length == 0
	 			@compiler_output = ( t 'submission.compiled_success' )
	 		end

	 		@submission.update_attributes(:compiler_output => @compiler_output )

	 		unless FileTest.exist?( exe_path )
				# Compiler error
				@submission.update_attributes(:status => ( t 'submission.status.compilation_error' ) , :judged => true )
				self.success = false
			end
	 	else
	 		cmd_line = Settings[ @lang ]['syntax_cmd']
	 		cmd_line = cmd_line % [ @code_path ]
	 		puts "Syntax Check #{cmd_line}"
	 		@compiler_output = %x[#{cmd_line}]
	 		@compiler_output = @compiler_output.to_s.strip

	 		if @compiler_output.length == 0
	 			@compiler_output = ( t 'submission.syntax_check' )
	 		end
	 		@submission.update_attributes(:compiler_output => @compiler_output )
	 	end
	 end

	 def link_or_copy(src, des)
	    begin
	      FileUtils.ln_s(src, des)
	    rescue NotImplementedError
	      FileUtils.cp(src,des)
	    end
	 end

	 def t( str )
		I18n.t str
	 end 
end