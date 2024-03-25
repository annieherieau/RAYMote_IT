class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :received_messages, as: :receiver, class_name: 'Message'
  has_many :notifications, as: :notifiable
  has_one :inbox, as: :inboxable

  #création de la boite de réception
  after_create :create_inbox

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  private

  def create_inbox
    Inbox.create(inboxable: self)
  end
end
