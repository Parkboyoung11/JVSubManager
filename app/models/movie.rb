class Movie < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :episodes, dependent: :destroy
  has_many :users, through: :favorites, dependent: :destroy
  validates :name, presence: true,
            uniqueness: {case_sensitive: false}
  validates :language, presence: true
end
