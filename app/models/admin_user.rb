class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable

  PASSWORD_SYMBOL_FORMAT = /\A(?=.*[^\w\s])[^\s]*\z/
  PASSWORD_REPEATED_CHAR_FORMAT = /\A(?!.*(.)\1\1).*\z/

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP,
                              message: "must be a valid email format" }, if: -> { email.present? }
  validates :password, presence: true, unless: :skip_password_validation?
  validates :password, length: { minimum: 8, maximum: 128 },
                       format: { with: PASSWORD_SYMBOL_FORMAT,
                                 message: "must contain at least one symbol" },
                       unless: :skip_password_validation?, if: -> { password.present? }
  validates :password, format: { with: PASSWORD_REPEATED_CHAR_FORMAT,
                                 message: "must not contain repeated characters" },
                       unless: :skip_password_validation?, if: -> { password.present? }

  def update_without_password(params)
    @skip_password_validation = true
    super(params)
  ensure
    @skip_password_validation = false
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email encrypted_password id id_value name remember_created_at
       reset_password_sent_at reset_password_token updated_at]
  end

  private

  def skip_password_validation?
    @skip_password_validation || false
  end
end
