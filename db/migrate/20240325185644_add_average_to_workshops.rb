class AddAverageToWorkshops < ActiveRecord::Migration[7.1]
  def change
    add_column :workshops, :average, :float, default: 0.0
  end
end
