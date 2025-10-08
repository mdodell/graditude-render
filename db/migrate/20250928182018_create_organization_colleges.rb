class CreateOrganizationColleges < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_colleges, id: false do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :college, null: false, foreign_key: true
    end

    add_index :organization_colleges, [ :organization_id, :college_id ], unique: true
  end
end
