class RenameMedicationTypeGroup < ActiveRecord::Migration
  def up
    rename_column :medication_types, :group, :category
    rename_column :medication_types, :name, :description
    add_column :medication_types, :name, :string
    add_index :medication_types, :name
  end

  def down
    rename_column :medication_types, :category, :group
    rename_column :medication_types, :description, :name
  end
end
