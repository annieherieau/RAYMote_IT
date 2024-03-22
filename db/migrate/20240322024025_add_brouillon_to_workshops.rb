class AddBrouillonToWorkshops < ActiveRecord::Migration[7.1]
  def change
    add_column :workshops, :brouillon, :boolean, default: true
  end
end
