class RemoveInvitedAtFromOrganizationMemberships < ActiveRecord::Migration[8.0]
  def change
    remove_column :organization_memberships, :invited_at, :timestamp
  end
end
