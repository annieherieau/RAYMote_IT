class Workshop < ApplicationRecord
  attr_accessor :tags_names
  after_save :assign_tags

  # Associations
  belongs_to :creator, class_name: 'User'
  has_many :attendances
  has_many :users, through: :attendances
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags

  # validations
  validates :name, presence: true, length: { in: 3..15 }
  validates :description, presence: true, length: { in: 20..500 }
  validates :price,  presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }

  private

  def assign_tags
    return if tags_names.blank?

    tags_names.split(',').map(&:strip).each do |name|
      tag = Tag.find_or_create_by(name: name)
      self.tags << tag unless self.tags.include?(tag)
    end
  end

end