class AddCategoryToWorkshops < ActiveRecord::Migration[7.1]
  def change
    add_reference :workshops, :category,  foreign_key: true
  end
end
