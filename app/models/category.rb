class Category < ApplicationRecord
    has_many :workshops
    has_one_attached :icon
end
