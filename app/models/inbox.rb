class Inbox < ApplicationRecord
  belongs_to :inboxable, polymorphic: true
  has_many :messages
end
