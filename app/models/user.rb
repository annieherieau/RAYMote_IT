class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # associations
  has_many :created_workshops, class_name: 'Workshop', foreign_key: :creator_id
  has_many :attendances
  has_many :workshops, through: :attendances
  has_many :likes, dependent: :destroy
  has_many :orders
  has_many :reviews
  has_many :sent_messages, as: :sender, class_name: 'Message'
  has_many :received_messages, as: :receiver, class_name: 'Message'
  has_many :notifications, as: :notifiable

  

  # validations
  validates :email, presence: true, uniqueness: true 

  after_create :welcome_send

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

  
end
