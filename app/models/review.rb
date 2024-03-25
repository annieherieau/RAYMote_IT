class Review < ApplicationRecord
  belongs_to :user
  belongs_to :workshop
  after_save :update_workshop_average_rating



  validates :user_id, presence: true
  validates :workshop_id, presence: true
  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :user_id, uniqueness: { scope: :workshop_id, message: "You have already reviewed this workshop" }

  private
#fait une moyenne des reviews du workshop à chaque review
  def update_workshop_average_rating
    workshop.update_average_rating
  end

end
