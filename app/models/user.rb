class User < ApplicationRecord
    has_secure_password
    
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 8 }, if: :password_present?
    has_secure_password
    
    before_save :downcase_email
  
    private
  
    def downcase_email
      self.email = email.downcase if email.present?
    end
  
    def password_present?
      password.present?  # Corrected method to check presence of password
    end
  end
  