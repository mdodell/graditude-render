class AddTokenToInvitations < ActiveRecord::Migration[8.1]
  def change
    add_column :invitations, :token, :string, null: false
    add_index :invitations, :token, unique: true
  end
end
