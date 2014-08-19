class HomeController < ApplicationController
  def index
    @beta_list_user = BetaListUser.new
  end

  def about

  end

  def contact

  end

  def pricing

  end

  def demo
    if user_signed_in?
      unless current_user.demo_account?
        redirect_to root_path, :notice => (t 'signed_in')
        return
      end
    else
      demo_user = User.find_by_email(Settings.demo_account_email)
      sign_in demo_user
    end
    redirect_to root_path, :notice => (t 'welcome')
  end

  def demo_register
    if user_signed_in?
      sign_out current_user
    end

    redirect_to new_user_registration_path
  end

  def faq

  end

  def interview
    @interview = Interview.new
  end

  def request_invite
    @beta_list_user = BetaListUser.new(params[:beta_list_user])

    if @beta_list_user.save
      render action: "request_invite"
    else
      render action: "index"
    end
  end

  def recharge_account
    
  end

  def feedback
  end
end
