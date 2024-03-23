class CreateInboxes < ActiveRecord::Migration[7.1]
  def change
    create_table :inboxes do |t|
      t.references :inboxable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
