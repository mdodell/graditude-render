class PopulateOrganizationMemberships < ActiveRecord::Migration[8.0]
  def up
    # Populate organization_memberships from existing roles
    Organization.find_each do |organization|
      # Get all users with roles for this organization
      %i[owner admin member].each do |role|
        User.with_role(role, organization).find_each do |user|
          # Check if membership already exists
          membership = OrganizationMembership.find_or_initialize_by(
            organization: organization,
            user: user
          )

          # Set timestamps if new record
          if membership.new_record?
            membership.joined_at = user.created_at  # Approximate join time
            membership.save!
            puts "Created membership for #{user.email} in #{organization.name}"
          end
        end
      end
    end
  end

  def down
    # This migration can't be easily reversed since we're creating new data
    # In a real rollback scenario, you'd want to decide if you want to keep the memberships
    puts "Warning: This migration cannot be safely reversed without potentially losing data."
  end
end
