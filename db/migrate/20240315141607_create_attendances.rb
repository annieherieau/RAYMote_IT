class CreateAttendances < ActiveRecord::Migration[7.1]
  def change
    create_table :attendances do |t|
      t.belongs_to :workshop, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
