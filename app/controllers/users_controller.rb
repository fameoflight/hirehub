class UsersController < ApplicationController
  before_filter :allowed?

  def index
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  protected

  def allowed?
    authenticate_user!

    if current_user.demo_account?
      flash[:error] = t 'errors.permission.demo_user_edit'
      redirect_to root_path
    end
  end

end
