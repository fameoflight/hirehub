class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def preview
    @submission = Submission.find_by_id(params[:id])
    @invite = Invite.find(@submission.submittable_id)

    @permission = true

    if @invite.has_relation(current_user.id) == 0
      @permission = false
    end

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def create
    @submission = Submission.new(params[:submission])

    @invite = Invite.find(@submission.submittable_id)

    @invite_problem_score = InviteProblemScore.find(:first, :conditions => ["invite_id = ? and problem_id = ? and problem_type = ?", @invite.id, @submission.problem_id, @submission.problem_type])

    #create new record if none exist
    if @invite_problem_score.nil?
      @invite_problem_score = InviteProblemScore.new
      @invite_problem_score.invite_id = @invite.id
      @invite_problem_score.problem_id = @submission.problem_id
      @invite_problem_score.problem_type = @submission.problem_type
      @invite_problem_score.save
    end
    @save_fail = false

    if @submission.save && @invite.save
      # This should not append to list but replace if there is existing record
      @invite.submissions << @submission
      if params[:compile]
        job = ProcessSubmissionJob.new(@submission.id, @invite.id, @invite_problem_score.id).compile_only
        @submission.reload
        @compile_job = job.compile_job
        if @compile_job.success
          @submission.update_attributes(:status => (t 'submission.status.compilation_only'), :judged => true)
        end
        #Delayed::Job.enqueue ProcessSubmissionJob.new( @submission.id , @invite.id , @invite_problem_score.id )
      end

      if params[:sample]
        job = ProcessSubmissionJob.new(@submission.id, @invite.id, @invite_problem_score.id).run_sample_only
        @submission.reload
        @compile_job = job.compile_job
        if @compile_job.success
          @compiler_output = @submission.compiler_output
          @sub_status = @submission.status
          @user_output = @submission.run_output
          @expected_output = @submission.problem_output_sample
        end
      end

      if params[:submit]
        flash[:notice] = ( t 'submission.recieved' )
        Delayed::Job.enqueue ProcessSubmissionJob.new(@submission.id, @invite.id, @invite_problem_score.id)
      end
    else
      @save_fail = true
      flash[:error] = (t 'submission.errors.default')
    end

    respond_to do |format|
      if params[:compile] || params[:sample]
        format.js { render :layout => false }
        format.html { redirect_to request.fullpath }
      end
      if params[:submit]
        format.js { render :layout => false }
        format.html { redirect_to solve_invite_path (@invite.url_hash) }
      end
    end
  end
end
