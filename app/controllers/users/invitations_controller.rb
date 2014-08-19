class Users::InvitationsController < Devise::InvitationsController

  def edit
    if user_signed_in?
       logger.debug "user already signed in"
       sign_out current_user
    end
    super
  end

  def update

    super
  end

  def after_accept_path_for(resource)
    unless resource.nil?
      path = latest_path(resource)
      unless path.nil?
        return path
      end
    end
    return root_url
  end

  private

  def latest_path (user)
    if user.recruiter?
      return root_url
    end

    last_invite = user.invitations().last

    unless last_invite.nil?
      return solve_invite_url(last_invite.url_hash)
    end

    last_interview = user.interview_invites().last

    unless last_interview.nil?
      return attend_interview_url(last_interview.url_hash)
    end

    return nil
  end

end
