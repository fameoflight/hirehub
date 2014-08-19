class InviteMailer < PostageApp::Mailer
  default from: "invite@hirehub.me"
  helper ApplicationHelper

  def invite_test_email(invite)
    @invite = invite
    mail(:to => @invite.candidate_email, :subject => ( t 'invite_test_email_subject' ))
  end

  def invite_interview_email(interview)
    @interview = interview
    mail(:to => @interview.candidate_email, :subject => ( t 'invite_interview_email_subject' ))
  end
end
