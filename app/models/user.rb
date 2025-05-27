class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable, :validatable and :omniauthable
  devise :database_authenticatable, :rememberable
  has_many :quotes, dependent: :destroy

  PASSWORD_SYMBOL_FORMAT = /\A(?=.*[^\w\s])[^\s]*\z/
  PASSWORD_REPEATED_CHAR_FORMAT = /\A(?!.*(.)\1\1).*\z/
  PHONE_FORMAT = /\A\+?[0-9\s-]{7,20}\z/

  validates :name,
            presence: true

  validates :email, presence: true
  validates :email, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" },
                    if: -> { email.present? }
  validates :phone,
            format: { with: PHONE_FORMAT,
                      message: "must be a valid phone number (digits, spaces, or dashes only, optional + at start)" },
            if: -> { phone.present? }, allow_nil: true

  validates :password,
            presence: true,
            unless: :skip_password_validation?
  validates :password,
            length: { minimum: 8, maximum: 128 },
            format: { with: PASSWORD_SYMBOL_FORMAT, message: "must contain at least one symbol" },
            unless: :skip_password_validation?, if: -> { password.present? }
  validates :password,
            format: { with: PASSWORD_REPEATED_CHAR_FORMAT, message: "must not contain repeated characters" },
            unless: :skip_password_validation?, if: -> { password.present? }

  validates :password_confirmation,
            presence: false,
            if: -> { password.present? }
  validates :password,
            confirmation: true,
            if: -> { password.present? }

  # This method is used in the User controller to update the user without changing the password.
  def update_without_password(params)
    @skip_password_validation = true
    super(params)
  ensure
    @skip_password_validation = false
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email phone encrypted_password id name remember_created_at reset_password_sent_at reset_password_token
       updated_at]
  end

  private

  def skip_password_validation?
    @skip_password_validation || false
  end
end
