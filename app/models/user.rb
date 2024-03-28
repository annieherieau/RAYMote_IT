class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Callbacks
  after_create :create_inbox, :create_settings, :welcome_send

  # associations
  has_many :created_workshops, class_name: 'Workshop', foreign_key: :creator_id, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :workshops, through: :attendances, foreign_key: :user_id
  has_many :likes, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :sent_messages, as: :sender, class_name: 'Message', dependent: :destroy
  has_many :received_messages, as: :receiver, class_name: 'Message', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_one :inbox, as: :inboxable, dependent: :destroy
  has_one_attached :avatar
  has_one :setting, dependent: :destroy

  # validations
  validates :email, presence: true, uniqueness: true 

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end

   private

  def create_inbox
    Inbox.create(inboxable: self)
  end

  def create_settings
    Setting.create!(user: self)
  end
end
