class Order < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :order_workshops
  has_many :workshops, through: :order_workshops


  # Validations
  validates :user, presence: true
  validates :workshops, presence: true


  # Callbacks
  before_save :amount



  # Methods
  def send_order_emails
    admins = User.where(admin: true)
    admins.each do |admin|
      UserMailer.order_to_admin(admin, self).deliver_now
    end
    UserMailer.order_to_user(self).deliver_now
  end

  def amount
    amount = 0
    workshops.each do |workshop|
      amount += workshop.price
    end
    amount
  end

  def add_workshop(workshop_ids)
    workshop_ids.each do |workshop_id|
      order_workshops.create(workshop_id: self.id, workshop_id: workshop_id)
    end
  end

end
