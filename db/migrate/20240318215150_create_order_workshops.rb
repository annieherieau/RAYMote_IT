class CreateOrderWorkshops < ActiveRecord::Migration[7.1]
  def change
    create_table :order_workshops do |t|
      t.belongs_to :user, index: true
      t.belongs_to :workshop, index: true
      t.timestamps
    end
  end
end
