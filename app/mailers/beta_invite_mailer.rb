class BetaInviteMailer < PostageApp::Mailer
  default from: "beta@hirehub.me"
  helper ApplicationHelper

  def send_access_code(beta_list_user_id)
    begin
     @beta_list_user = BetaListUser.find( beta_list_user_id )

     @user = User.find_or_create(@beta_list_user.email, @beta_list_user.name, 'recruiter')

     mail(:to => @user.email_address_with_name, :subject => (t 'beta_list.email_subject'))
     return true
    rescue
        return false
    end
  end
end
