class User < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :movies, through: :favorites, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many :movies, through: :histories, dependent: :destroy
  has_many :watchings, dependent: :destroy
  has_many :episodes, through: :watchings, dependent: :destroy
  before_save{email.downcase!}
  before_save{username.downcase!}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :username, presence: true, length: {maximum: 50},
            uniqueness: {case_sensitive: false}
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  def store_api_key
    api_key = SecureRandom.urlsafe_base64
    update_attribute(:api_key, api_key)
  end

  def store_activation_token
    activation_token = SecureRandom.urlsafe_base64
    update_attribute(:activation_token, activation_token)
  end

end
