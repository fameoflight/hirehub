class InvitesController < ApplicationController
  before_filter :allowed_new?, :only => [:index, :show, :new, :create]

  before_filter :allowed_solve?, :only => [:welcome_solve, :agree_submit, :solve, :solve_problem, :solve_code_problem, :finish, :refresh_submissions]

  # GET /invites
  # GET /invites.json
  def index
    @invites = current_user.invites
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invites }
    end
    session[:new_invite_error] = nil
    session[:new_invite_error_url] = nil
  end

  # GET /invites/1
  # GET /invites/1.json
  def show
    @invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.json
  def new
    flag_no_problem = current_user.problems.count + current_user.code_problems.count
    flag_no_collection = current_user.collections.count
    flag_no_balance = current_user.invite_balance

    if flag_no_problem == 0 
      error_message = (t 'invite.errors.no_problem')
      error_message_url = new_problem_url
    else
      if flag_no_collection == 0 
        error_message = t 'invite.errors.no_collection'
        error_message_url = new_collection_url
      else
        if flag_no_balance == 0
           error_message = t 'invite.errors.nil_balance'
           error_message_url = recharge_url
        end
      end
    end
    session[:new_invite_error] = error_message
    session[:new_invite_error_url] = error_message_url
    logger.warn session[:new_invite_error]

    if flag_no_balance == 0 || flag_no_collection == 0 || flag_no_problem == 0
      redirect_to invites_path
      return
    end

    @invite = Invite.new

    @invite.instruction = render_to_string 'invites/_instruction', :layout => false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invite }
    end
  end

  # POST /invites
  # POST /invites.json
  def create

    @invite = Invite.new(params[:invite])

    @invite.user_id = current_user.id

    @invite.url_hash = get_new_invite_hash

    candidate = User.find_or_create(@invite.candidate_email, @invite.candidate_name, 'candidate')

    if candidate.nil?
      render action: "new"
      return
    end

    @invite.candidate_id = candidate.id
    #Need to generate the hash and check whether mail was successfully being sent before savnig the
    #db record. The probability of failing to save the db record is very small compare to probability of
    #fail to send the record

    respond_to do |format|
      if @invite.save

        current_user.invite_balance = current_user.invite_balance - 1
        current_user.save

        InviteMailer.delay.invite_test_email(@invite)

        format.html { redirect_to invites_path, notice: (t 'invite.sent') }
        format.json { render json: @invite, status: :created, location: @invite }
      else
        format.html { render action: "new" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  # No edit , update or destroy on invite

  # # GET /invites/1/edit
  def edit
    @invite = Invite.find(params[:id])
  end

  # # PUT /invites/1
  # # PUT /invites/1.json
  def update
    @invite = Invite.find(params[:id])

    respond_to do |format|
      if @invite.update_attributes(params[:invite])
        format.html { redirect_to @invite, notice: (t 'invite.update') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def welcome_solve
    if no_relation
      return
    end

    if @invite.has_relation(current_user.id) == 2
      redirect_to solve_invite_path(params[:url_hash])
    end

    if @invite.agree
      redirect_to solve_invite_path(params[:url_hash])
    end
  end

  def agree_submit
    if no_relation
      return
    end

    if @invite.has_relation(current_user.id) == 2
      redirect_to solve_invite_path(params[:url_hash])
    end

    if @invite.agree
      flash[:notice] = ( t 'invite.redirecting' )
      redirect_to solve_invite_path(@invite.url_hash)
      return
    end

    @invite.update_attributes(params[:invite])

    if @invite.agree
      flash[:notice] = ( t 'invite.welcome' )
      @invite.start_time = Time.now
      @invite.save
      redirect_to solve_invite_path(@invite.url_hash)
    else
      flash[:error] = ( t 'invite.errors.not_agree' )
      redirect_to welcome_solve_path(@invite.url_hash)
    end
  end

  def solve
    if no_relation
      return
    end

    if @invite.has_relation(current_user.id) == 1
      if @invite.agree == false
        redirect_to welcome_solve_path(params[:url_hash])
        return
      end
    end

    @url_hash = params[:url_hash]

    respond_to do |format|
      format.html # solve.html.erb
      format.json { render json: @invite }
    end
  end

  def solve_problem
    if no_relation
      return
    end

    #do not allow submission if time is out
    if @invite.finished?
      flash[:error] = t 'invite.time_over'
      redirect_to root_path
      return
    end

    @submission = Submission.new

    #There are serious security lapse as the complete problem object will be exposed to the user
    #Also no validation whether this particular problem belongs to the invite for which its is being rendered

    @problem = @invite.collection.problems.find_by_id(params[:problem_id])

    if @problem.nil?
      flash[:error] = t 'invite.errors.problem_not_found'
      redirect_to solve_invite_path(@invite.url_hash)
      return
    end


    respond_to do |format|
      format.html # solve_problem.html.erb
      format.json { render json: @invite }
    end
  end

  def solve_code_problem
    if no_relation
      return
    end

    #do not allow submission if time is out
    if @invite.finished?
      flash[:error] = t 'invite.time_over'
      redirect_to root_path
      return
    end

    @submission = Submission.new

    #There are serious security lapse as the complete problem object will be exposed to the user
    #Also no validation whether this particular problem belongs to the invite for which its is being rendered

    @code_problem = @invite.collection.code_problems.find_by_id(params[:code_problem_id])

    if @code_problem.nil?
      flash[:error] = t 'invite.errors.problem_not_found'
      redirect_to solve_invite_path(@invite.url_hash)
      return
    end

    respond_to do |format|
      format.html # solve_problem.html.erb
      format.json { render json: @invite }
    end
  end

  def finish
    if @invite.has_relation(current_user.id) == 2
      flash[:error] = ( t 'invite.errors.recruiter_finish' )
      redirect_to solve_invite_path(params[:url_hash])
      return
    end

    if @invite.agree == false
      redirect_to welcome_solve_path(params[:url_hash])
      return
    end

    if @invite.finished?
      flash[:error] = ( t 'invite.errors.already_finished' )
    else
      @invite.user_finish = true
      @invite.finish_time = Time.now
      @invite.save
    end
  end

  def refresh_submissions
    respond_to do |format|
      format.js { render :layout => false }
      format.html { redirect_to solve_invite_path(@invite.url_hash) }
    end
  end

  protected

  def allowed_new?
    authenticate_user!

    if current_user.recruiter? == false
      flash[:error] = t 'errors.permission.default'
      redirect_to root_path
    end
  end

  def allowed_solve?
    authenticate_user!

    @invite = Invite.find_by_url_hash(params[:url_hash])

    if @invite.nil?
      flash[:error] = t 'invite.errors.not_found'
      redirect_to root_path
      return
    end

    if @invite.has_relation(current_user.id) == 0
      flash[:error] = t 'errors.permission.default'
      redirect_to root_path
    end
  end

  private

  def no_relation
    if @invite.has_relation(current_user.id) == 0
      flash[:error] = t 'errors.permission.default'
      redirect_to root_path
      return true
    end
    return false
  end

  def get_new_invite_hash()
    hash = SecureRandom.hex(16)

    while Invite.find_by_url_hash(hash).nil? == false
      hash = SecureRandom.hex(16)
    end
    return hash
  end
end
