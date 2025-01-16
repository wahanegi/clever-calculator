class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable

  PASSWORD_SYMBOL_FORMAT = /\A(?=.*[^\w\s])[^\s]*\z/
  PASSWORD_REPEATED_CHAR_FORMAT = /\A(?!.*(.)\1\1).*\z/

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" }
  validates :password, length: { minimum: 8, maximum: 128 },
            format: { with: PASSWORD_SYMBOL_FORMAT, message: "must contain at least one symbol" }
  validates :password, format: { with: PASSWORD_REPEATED_CHAR_FORMAT, message: "must not contain repeated characters" }
end
