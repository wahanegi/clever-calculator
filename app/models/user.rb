class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  NAME_FORMAT = /\A[a-zA-Z0-9_]+\z/
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PASSWORD_SYMBOL_FORMAT = /\A(?=.*[^\w\s])[^\s]*\z/
  PASSWORD_REPEATED_CHAR_FORMAT = /\A(?!.*(.)\1\1).*\z/

  validates :name, presence: true, format: { with: NAME_FORMAT, message: "must be alphanumeric" }
  validates :email, presence: true, uniqueness: true,
                    format: { with: EMAIL_FORMAT, message: "must be a valid email format" }
  validates :password, length: { minimum: 8, maximum: 128 },
                       format: { with: PASSWORD_SYMBOL_FORMAT, message: "must contain at least one symbol" }
  validates :password, format: { with: PASSWORD_REPEATED_CHAR_FORMAT, message: "must not contain repeated characters" }
end