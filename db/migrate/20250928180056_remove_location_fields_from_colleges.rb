class RemoveLocationFieldsFromColleges < ActiveRecord::Migration[8.0]
  def change
    remove_column :colleges, :city, :string
    remove_column :colleges, :state, :string
    remove_column :colleges, :country, :string
  end
end
