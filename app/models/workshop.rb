class Workshop < ApplicationRecord
    has_many :attendances
    has_many :users, through: :attendances
    has_many :likes, dependent: :destroy
  end
