class Episode < ApplicationRecord
  has_many :watchings, dependent: :destroy
  has_many :users, through: :watchings, dependent: :destroy
  belongs_to :movie
end
