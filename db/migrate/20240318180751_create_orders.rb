class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.datemine :date

      
      t.timestamps
    end
  end
end
