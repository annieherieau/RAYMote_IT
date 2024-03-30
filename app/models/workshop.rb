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
  has_many :order_workshops, dependent: :destroy
  has_many :orders, through: :order_workshops
  has_many :course_items, dependent: :destroy
  accepts_nested_attributes_for :course_items, allow_destroy: true
  has_one_attached :photo

  # validations
  validates :name, presence: true, length: { in: 3..100 }
  validates :description, presence: true, length: { in: 20..1000 }
  validates :price,  presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
  # validates_comparison_of :start_date, greater_than: DateTime.now
  validates :duration, numericality: { only_integer: true, greater_than: 0 }, if: :is_multiple_of_5?

  def tags_destroy
    self.tags.clear
  end


  #fais une moyenne des notes des reviews
  def update_average_rating
    update_column(:average, reviews.average(:rating).to_f)
  end
  # status des workshops en fonction de la date
  def status
    if self.event
      end_date = start_date + duration.minutes
      if start_date > Time.current
        'à venir'
      elsif end_date < Time.current
        'passé'
      else
        'en cours'
      end
    else
      false
    end
  end

  def default_photo
    self.event ? url = 'app/assets/images/video-01.jpg' : url = 'app/assets/images/course-01.jpg'
    self.photo.attach(io: File.open(url), filename: url.split('/').last)
  end

  # text d'affichage des boutons toggles
  def activate_btn
    self.brouillon ? "Publier" : "Dépublier"
  end

  def validate_btn
    self.brouillon ? "Valider" : "Refuser"
  end

  def date_format
    start_date ? start_date.strftime("%d/%m/%Y à %H:%M") : ''
  end

  def duration_format
    hours = (duration / 60).to_s.rjust(2,'0')
    minutes = (duration % 60).to_s.rjust(2,'0')
    return "#{hours}:#{minutes}" 
  end

  def end_date
    start_date + duration * 60
  end

  private

  def assign_tags
    return if tags_names.blank?

    tags_names.split(',').map(&:strip).each do |name|
      tag = Tag.find_or_create_by(name: name)
      self.tags << tag unless self.tags.include?(tag)
    end
  end

  def is_multiple_of_5?
    if (duration % 5) > 0
      errors.add(:durée, "en minutes, doit être un multiple de 5")
      return false
    end
  end

end