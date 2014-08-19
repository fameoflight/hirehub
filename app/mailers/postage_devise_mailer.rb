class PostageDeviseMailer < PostageApp::Mailer
    include Devise::Mailers::Helpers

    default from: "noreply@hirehub.me"

    def confirmation_instructions(record,opts)
        devise_mail(record, :confirmation_instructions)
    end

    def reset_password_instructions(record,opts)
        devise_mail(record, :reset_password_instructions)
    end

    def unlock_instructions(record,opts)
        devise_mail(record, :unlock_instructions)
    end
end