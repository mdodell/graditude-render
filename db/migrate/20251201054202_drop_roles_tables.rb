class DropRolesTables < ActiveRecord::Migration[8.1]
  def change
    # Drop join table first
    drop_table :users_roles, if_exists: true

    # Drop roles table
    drop_table :roles, if_exists: true
  end
end
