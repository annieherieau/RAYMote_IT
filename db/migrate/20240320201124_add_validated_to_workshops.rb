class AddValidatedToWorkshops < ActiveRecord::Migration[7.1]
  def change
    add_column :workshops, :validated, :boolean, default: false
  end
end
