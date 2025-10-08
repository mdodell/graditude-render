class AddCollegeToOrganizations < ActiveRecord::Migration[8.0]
  def change
    add_reference :organizations, :college, null: true, foreign_key: true
  end
end
