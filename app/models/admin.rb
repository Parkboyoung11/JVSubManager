class Admin < ApplicationRecord
  ADMIN_ATTRIBUTE = [:name, :password, :password_confirmation].freeze

  validates :name, presence: true, length: {maximum: Settings.name_maximum}
  validates :password, presence: true,
            length: {minimum: Settings.pass_minimun}, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = Admin.choose_cost
      BCrypt::Password.create(string, cost: cost)
    end

    def choose_cost
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    end
  end

end
