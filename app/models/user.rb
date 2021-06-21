class User < ApplicationRecord
  has_one_attached :image
  has_many :rates, dependent: :destroy

  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PHONE_REGEX = /\A\d[0-9]{9}\z/.freeze
  validates :name, presence: true,
                   length: {maximum: Settings.user.name.max_length}
  validates :email, presence: true,
                    length: {maximum: Settings.user.email.max_length},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  validates :address, presence: true
  validates :phone, presence: true,
                    format: {with: VALID_PHONE_REGEX}
  validates :password, presence: true,
                       length: {minimum: Settings.user.password.min_length},
                       allow_nil: true
  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
