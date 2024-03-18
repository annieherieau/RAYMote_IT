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


  # After create
  # after_create :send_alert_to_admin
  # after_create :send_alert_to_user


  # Methods
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


  # private

  # def send_alert_to_admin
  #   if order.present? 
  #     UserMailer.order_alert_admin(admin).deliver_now
  #   end
  # end

  # def send_alert_to_user
  #   if order.present?
  #     UserMailer.order_alert_user(user).deliver_now
  #   end
  # end

end
