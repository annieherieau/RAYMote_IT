class Workshop < ApplicationRecord
  # Associations
  has_many :attendances
  has_many :users, through: :attendances
  has_many :likes, dependent: :destroy

  # validations
  validates :name, presence: true, length: { in: 3..15 }
  validates :description, presence: true, length: { in: 20..500 }
  validates :price,  presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
end
