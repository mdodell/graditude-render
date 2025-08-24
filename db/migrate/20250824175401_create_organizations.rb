class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :domain
      t.string :description, limit: 250

      t.timestamps
    end
    add_index :organizations, :domain, unique: true
  end
end
