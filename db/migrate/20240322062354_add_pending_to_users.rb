class AddPendingToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pending, :boolean
  end
end
