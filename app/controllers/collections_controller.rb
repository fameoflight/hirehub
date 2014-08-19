class CollectionsController < ApplicationController
   before_filter :allowed_new?, :only => [:new, :create,:edit,:update]
   before_filter :authenticate_user!, :only => [:show,:index]

  def index
    @collections = current_user.collections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections }
    end
    session[:new_collection_error] = nil
    session[:new_collection_error_url] = nil
  end

  def show
    @collection = Collection.find(params[:id])

    if @collection.user_id != current_user.id
      flash[:error] = t 'errors.permission.default'
      redirect_to root_path
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collection }
    end
  end

  def new
    flag = current_user.problems.count + current_user.code_problems.count

    if flag == 0
      session[:new_collection_error] = t 'collection.errors.no_problem'
      session[:new_collection_error_url] = new_problem_url
      redirect_to collections_path
      return
    end

    @collection = Collection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collection }
    end
  end

  def create
    @collection = Collection.new(params[:collection])
    @collection.user_id = current_user.id

    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: ( t 'collection.created') }
        format.json { render json: @collection, status: :created, location: @collection }
      else
        logger.debug @collection.errors.full_messages
        format.html { render action: "new" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @collection = Collection.find(params[:id])
  end

  def update
    @collection = Collection.find(params[:id])

    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        format.html { redirect_to @collection, notice: (t 'collection.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
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

end
