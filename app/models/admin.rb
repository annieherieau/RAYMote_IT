class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :received_messages, as: :receiver, class_name: 'Message'
  has_many :notifications, as: :notifiable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
end
