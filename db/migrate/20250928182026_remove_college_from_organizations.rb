class RemoveCollegeFromOrganizations < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :organizations, :colleges
    remove_reference :organizations, :college, null: true, foreign_key: false
  end
end
