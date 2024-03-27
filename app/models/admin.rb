class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :sent_messages, as: :sender, class_name: 'Message', dependent: :destroy
  has_many :received_messages, as: :receiver, class_name: 'Message', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_one :inbox, as: :inboxable, dependent: :destroy

  #création de la boite de réception
  after_create :create_inbox

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  private

  def create_inbox
    Inbox.create(inboxable: self)
  end
end
