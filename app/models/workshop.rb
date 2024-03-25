class Workshop < ApplicationRecord
  attr_accessor :tags_names
  after_save :assign_tags
  belongs_to :category, optional: true
  after_save :update_average_rating

  # Associations
  belongs_to :creator, class_name: 'User'
  has_many :attendances, dependent: :destroy
  has_many :users, through: :attendances
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :reviews, dependent: :destroy
  has_many :order_workshops
  has_many :orders, through: :order_workshops

  # validations
  validates :name, presence: true, length: { in: 3..15 }
  validates :description, presence: true, length: { in: 20..500 }
  validates :price,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }

def tags_destroy
  self.tags.clear
end



def update_average_rating
  update_column(:average, reviews.average(:rating).to_f)
end

def status
  end_date = start_date + duration.minutes
  if start_date > Time.current
    'à venir'
  elsif end_date < Time.current
    'passé'
  else
    'en cours'
  end
end

def activate_btn
  self.brouillon ? "Publier" : "Dépublier"
end

def validate_btn
  self.brouillon ? "Valider" : "Refuser"
end

  private

  def assign_tags
    return if tags_names.blank?

    tags_names.split(',').map(&:strip).each do |name|
      tag = Tag.find_or_create_by(name: name)
      self.tags << tag unless self.tags.include?(tag)
    end
  end

end