class Workshop < ApplicationRecord
  attr_accessor :tags_names
  after_save :assign_tags
  belongs_to :category, optional: true

  # Associations
  belongs_to :creator, class_name: 'User'
  has_many :attendances, dependent: :destroy
  has_many :users, through: :attendances
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :reviews

  # validations
  validates :name, presence: true, length: { in: 3..15 }
  validates :description, presence: true, length: { in: 20..500 }
  validates :price,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }

def tags_destroy
  self.tags.clear
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