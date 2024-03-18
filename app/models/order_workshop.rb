class OrderWorkshop < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :workshop
end
