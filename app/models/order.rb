class Order < ApplicationRecord

  # Associations
  belongs_to :user
  has_many :order_workshops
  has_many :workshops, through: :order_workshops

  # Validations
  validates :user, presence: true

  # Methods
  def send_order_emails
    # TODO : envoi email au User
    # UserMailer.order_to_user(self).deliver_now

    # TODO : envoi email au Creator
    # faire une boucle pour chaque Workshop > envoyer au creator
    # UserMailer.order_to_creator(???).deliver_now

    # TODO: envoi email à Admin
    # admins = User.where(admin: true)
    # admins.each do |admin|
    #   UserMailer.order_to_admin(admin, self).deliver_now
    # end

    
  end

  # calcult du total de la commande (pour feature Panier)
  def amount
    amount = 0
    self.workshops.each do |workshop|
      amount += workshop.price
    end
    amount
  end

  # ajoute les workshop (pour Feature Panier)
  def add_workshops(workshop_ids)
    workshop_ids.each do |workshop_id|
      OrderWorkshop.create(order_id: self.id, workshop_id: workshop_id)
    end
  end

end
