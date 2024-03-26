class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # création de la boite de réception
  after_create :create_inbox

  # associations
  has_many :created_workshops, class_name: 'Workshop', foreign_key: :creator_id, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :workshops, through: :attendances, dependent: :destroy, foreign_key: :user_id
  has_many :likes, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :sent_messages, as: :sender, class_name: 'Message', dependent: :destroy
  has_many :received_messages, as: :receiver, class_name: 'Message', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_one :inbox, as: :inboxable, dependent: :destroy
  has_one_attached :avatar

  

  # validations
  validates :email, presence: true, uniqueness: true 

  after_create :welcome_send

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

   private

  def create_inbox
    Inbox.create(inboxable: self)
  end
end
