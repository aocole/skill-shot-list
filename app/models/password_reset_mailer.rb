class PasswordResetMailer < ActionMailer::Base
  default_url_options[:host] = "skillshot.ndrew.org"
  default from: "Skill Shot Website <noreply@#{default_url_options[:host]}>"

  def password_reset_instructions(user, request)
    options = {
      id: user.perishable_token,
      host: request.host,
      protocol: request.protocol
    }
    if request.port != 80
       options[:port] = request.port
    end
    @edit_password_reset_url = edit_password_reset_url(options)
    mail to: user.email, subject: "Password Reset Instructions", body: "A request to reset your password has been made.
If you did not make this request, simply ignore this email.
If you did make this request just click the link below:
#{@edit_password_reset_url}
If the above URL does not work try copying and pasting it into your browser.
This link expires in #{User.perishable_token_valid_for/1.minute} minutes. If the link has expired you will need to start
the password reset process over again.
If you continue to have problems please feel free to contact us."
  end

end