class DropProgramsAndProgramMemberships < ActiveRecord::Migration[8.1]
  def change
    # Remove foreign keys first
    remove_foreign_key :program_memberships, :programs, if_exists: true
    remove_foreign_key :program_memberships, :users, if_exists: true
    remove_foreign_key :programs, :organizations, if_exists: true

    # Drop tables (program_memberships first since it references programs)
    drop_table :program_memberships, if_exists: true
    drop_table :programs, if_exists: true
  end
end
