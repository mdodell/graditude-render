class CreateOrganizationMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_memberships do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :invitation, null: true, foreign_key: true
      t.timestamp :joined_at, null: false
      t.timestamp :invited_at

      t.timestamps
    end

    add_index :organization_memberships, [ :organization_id, :user_id ], unique: true
    add_index :organization_memberships, [ :user_id, :organization_id ]
  end
end
