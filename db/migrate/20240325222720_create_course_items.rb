class CreateCourseItems < ActiveRecord::Migration[7.1]
  def change
    create_table :course_items do |t|
      t.string :link
      t.references :workshop, null: false, foreign_key: true

      t.timestamps
    end
  end
end
