class InterviewsController < ApplicationController
  before_filter :authenticate_user!

  # GET /interviews
  # GET /interviews.json
  def index
    @interviews = current_user.interviews

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @interviews }
    end
  end

  # GET /interviews/1
  # GET /interviews/1.json
  def show
    @interview = Interview.find(params[:id])

    if @interview.user_id != current_user.id
      redirect_to root_path, :notice => ( t 'errors.permission.default' )
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @interview }
    end
  end

  # GET /interviews/new
  # GET /interviews/new.json
  def new
    @interview = Interview.new

    @interview.timezone = current_user.timezone

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @interview }
    end
  end

  # GET /interviews/1/edit
  def edit
    @interview = Interview.find(params[:id])

    if @interview.user_id != current_user.id
      redirect_to root_path, :notice => ( t 'errors.permission.default' )
      return
    end
  end

  # POST /interviews
  # POST /interviews.json
  def create
    @interview = Interview.new(params[:interview])

    @interview.user_id = current_user.id
    @interview.url_hash = get_new_interview_hash

    candidate = User.find_or_create(@interview.candidate_email, @interview.candidate_name, 'candidate')

    if candidate.nil?
      render action: "new"
      return
    end

    @interview.candidate_id = candidate.id

    respond_to do |format|
      if @interview.save

        InviteMailer.delay.invite_interview_email(@interview)

        format.html { redirect_to interviews_path, notice: ( t 'interview.created' ) }
        format.json { render json: @interview, status: :created, location: @interview }
      else
        format.html { render action: "new" }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /interviews/1
  # PUT /interviews/1.json
  def update
    @interview = Interview.find(params[:id])

    if @interview.user_id != current_user.id
      redirect_to root_path, :notice => ( t 'errors.permission.default' )
      return
    end

    respond_to do |format|
      if @interview.update_attributes(params[:interview])
        format.html { redirect_to interviews_path, notice: ( t 'interview.updated' ) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @interview.errors, status: :unprocessable_entity }
      end
    end
  end

  def attend
    @interview = Interview.find_by_url_hash(params[:url_hash])

    if @interview.nil?
      flash[:error] = ( t 'interview.errors.not_found' )
      redirect_to root_path
      return
    end
  end

  def review
    @interview = Interview.find_by_url_hash(params[:url_hash])

    if @interview.nil?
      flash[:error] = ( t 'interview.errors.not_found' )
      redirect_to root_path
      return
    end
  end

  private

  def get_new_interview_hash()
    hash = SecureRandom.hex(16)

    while Interview.find_by_url_hash(hash).nil? == false
      hash = SecureRandom.hex(16)
    end
    return hash
  end
end
