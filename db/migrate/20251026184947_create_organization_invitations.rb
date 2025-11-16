class CreateOrganizationInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_invitations do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :email, null: false
      t.string :invite_code, null: false
      t.datetime :expires_at, null: false
      t.datetime :accepted_at
      t.references :accepted_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :organization_invitations, :invite_code, unique: true
    add_index :organization_invitations, [ :organization_id, :email ]
    add_index :organization_invitations, :expires_at
  end
end
