class Message < ApplicationRecord
    belongs_to :sender, polymorphic: true
    belongs_to :receiver, polymorphic: true
end
