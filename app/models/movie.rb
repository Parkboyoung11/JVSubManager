class Movie < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites, dependent: :destroy
end
