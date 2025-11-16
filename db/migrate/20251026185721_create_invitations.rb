class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations do |t|
      t.references :invitable, polymorphic: true, null: false
      t.string :email, null: false
      t.string :invite_code, null: false
      t.datetime :expires_at, null: false
      t.datetime :accepted_at
      t.references :accepted_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :invitations, :invite_code, unique: true
    add_index :invitations, [ :invitable_type, :invitable_id, :email ]
    add_index :invitations, :expires_at
  end
end
