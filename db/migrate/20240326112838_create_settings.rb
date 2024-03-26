class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.boolean :high_contrast, default: false
      t.boolean :opendys, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
