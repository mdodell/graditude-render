class DropOrganizationInvitationsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :organization_invitations, if_exists: true
  end
end
