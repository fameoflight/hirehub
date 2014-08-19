class ProblemsController < ApplicationController
  before_filter :allowed?

  before_filter :editable_problem, :only => [:edit, :update]
  # GET /problems
  # GET /problems.json
  def index
    @problems = current_user.problems

    @code_problems = current_user.code_problems

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @problems }
    end
  end

  # GET /problems/1
  # GET /problems/1.json
  def show
    @problem = Problem.find(params[:id])

    @code_problem = CodeProblem.new

    if @problem.user_id != current_user.id
      flash[:error] = t 'errors.permission.default'
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @problem }
    end
  end

  # GET /problems/new
  # GET /problems/new.json
  def new
    @problem = Problem.new

    @problem.statement = render_to_string 'problems/_format', :layout => false

    @code_problem = CodeProblem.new

    @code_problem.statement = render_to_string 'code_problems/_format', :layout => false

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @problem }
    end
  end

  # POST /problems
  # POST /problems.json
  def create
    @problem = Problem.new(params[:problem])
    @problem.user_id = current_user.id
    @code_problem = CodeProblem.new
    @code_problem.statement = render_to_string 'code_problems/_format', :layout => false

    if @problem.save
      redirect_to problems_path, notice: (t 'problem.create')
    else
      render action: "new"
    end
  end

  # GET /problems/1/edit
  def edit
    @code_problem = CodeProblem.new
  end

  # PUT /problems/1
  # PUT /problems/1.json
  def update
    @code_problem = CodeProblem.new
    @code_problem.statement = render_to_string 'code_problems/_format', :layout => false

    respond_to do |format|
      if @problem.update_attributes(params[:problem])
        format.html { redirect_to @problem, notice: (t 'problem.update.default') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @problem.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @problem = Problem.find(params[:id])

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

    @problem = Problem.find(params[:id])

    if @problem.user_id != current_user.id
      flash[:error] = t 'errors.permission.modify_problem'
      redirect_to root_path
    end
  end
end
