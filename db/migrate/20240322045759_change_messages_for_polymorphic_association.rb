class ChangeMessagesForPolymorphicAssociation < ActiveRecord::Migration[7.1]
    def change
      remove_column :messages, :sender_id, :integer
      remove_column :messages, :receiver_id, :integer
      add_reference :messages, :sender, polymorphic: true, index: true
      add_reference :messages, :receiver, polymorphic: true, index: true
    end
end
