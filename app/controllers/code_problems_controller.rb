class CodeProblemsController < ApplicationController
  before_filter :allowed?

  before_filter :editable_problem, :only => [:show, :edit, :update]

  # GET /code_problems
  # GET /code_problems.json
  def index
    @code_problems = current_user.code_problems

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @code_problems }
    end
  end

  # GET /code_problems/1
  # GET /code_problems/1.json
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @code_problem }
    end
  end

  # GET /code_problems/new
  # GET /code_problems/new.json
  def new
    @code_problem = CodeProblem.new

    @code_problem.statement = render_to_string 'code_problems/_format', :layout => false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @code_problem }
    end
  end

  # POST /code_problems
  # POST /code_problems.json
  def create
    @code_problem = CodeProblem.new(params[:code_problem])
    @code_problem.user_id = current_user.id


    if @code_problem.save
      redirect_to problems_path, notice: (t 'problem.create')
    else
      render action: "new"
    end
  end

  # GET /code_problems/1/edit
  def edit

  end

  # PUT /code_problems/1
  # PUT /code_problems/1.json
  def update
    if @code_problem.update_attributes(params[:code_problem])
      message = t 'problem.update.default'
      if params[:sample]
        message = t 'problem.update.sample_data'
      end
      if params[:testdata]
        message = t 'problem.update.test_data'
      end
      redirect_to problems_path, notice: message
    else
      message = t 'problem.update.errors.default'
      if @code_problems.sample_input.to_s.length == 0
        message = t 'problem.update.errors.sample_data'
      end
      redirect_to problems_path, notice: message
    end
  end

  def preview
    @code_problem = CodeProblem.find(params[:id])

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  protected

  def allowed?
    authenticate_user!

    if current_user.recruiter? == false
      flash[:error] = t 'errors.permission.default'
      redirect_to root_path
    end
  end

  def editable_problem
    authenticate_user!

    @code_problem = CodeProblem.find(params[:id])

    if @code_problem.user_id != current_user.id
      flash[:error] = t 'errors.permission.modify_problem'
      redirect_to root_path
    end
  end
end
