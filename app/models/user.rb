class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.validate_email_field = ::Rails.env != 'development'
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end
  validates_format_of :initials, :with => /[A-Z0-9 ]{1,3}/

  def deliver_password_reset_instructions!(request)
    reset_perishable_token!
    PasswordResetMailer.password_reset_instructions(self, request).deliver
  end
end
