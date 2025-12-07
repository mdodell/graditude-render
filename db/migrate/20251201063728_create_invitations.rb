class CreateInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.integer :status
      t.references :invitable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
