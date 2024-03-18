class OrderWorkshop < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :workshop
end
