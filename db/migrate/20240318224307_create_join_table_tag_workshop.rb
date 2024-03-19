class CreateJoinTableTagWorkshop < ActiveRecord::Migration[7.1]
  def change
    create_join_table :tags, :workshops do |t|
       t.index [:tag_id, :workshop_id]
       t.index [:workshop_id, :tag_id]
    end
  end
end
