class CreateWorkshops < ActiveRecord::Migration[7.1]
  def change
    create_table :workshops do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.datetime :start_date
      t.integer :duration
      t.boolean :event, null: false, default: false
      t.timestamps
    end
  end
end
