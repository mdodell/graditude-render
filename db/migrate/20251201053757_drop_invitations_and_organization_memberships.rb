class DropInvitationsAndOrganizationMemberships < ActiveRecord::Migration[8.1]
  def change
    # Remove foreign keys first
    # Remove from organization_memberships
    remove_foreign_key :organization_memberships, :invitations, if_exists: true
    remove_foreign_key :organization_memberships, :organizations, if_exists: true
    remove_foreign_key :organization_memberships, :users, if_exists: true

    # Remove from program_memberships (still exists in schema even though code was removed)
    remove_foreign_key :program_memberships, :invitations, if_exists: true

    # Remove from invitations
    remove_foreign_key :invitations, :users, column: :accepted_by_id, if_exists: true

    # Drop tables (organization_memberships first since it references invitations)
    drop_table :organization_memberships, if_exists: true
    drop_table :invitations, if_exists: true
  end
end
