class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def home
    @invites = current_user.invites
  end

  def grant_access
    @beta_list_user = BetaListUser.find( params[:beta_list_id] )
    @success = BetaInviteMailer.delay.send_access_code( @beta_list_user.id )
    if @success
        @beta_list_user.email_sent = true
        @success = @beta_list_user.save
    end
    logger.debug @beta_list_user.errors.full_messages
  end

  def admin_signin_user
    @redirect_url = nil

    unless params[:user]
      @redirect_url = root_path
    else
      if current_user.admin?
        user = User.find_by_email( params[:user][:email] )
        if user.nil?
          @message = 'Unknown user'
        else
          sign_out current_user
          sign_in user
          @redirect_url = dashboard_home_path
        end
      else
        @message = 'You cannot login using this email'
      end
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :layout => false }
    end
  end
end
