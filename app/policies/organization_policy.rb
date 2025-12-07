# app/policies/organization_policy.rb
class OrganizationPolicy < ApplicationPolicy
  # Define constants for clarity
  OWNER_ROLES = [ :owner ].freeze
  ADMIN_ROLES = [ :admin, :owner ].freeze
  MEMBER_ROLES = [ :member, :admin, :owner ].freeze

  # --- General Access ---

  def index?
    # Anyone who is logged in can view the index of organizations (to see which they belong to)
    user.present?
  end

  def show?
    # Only users who are members of this specific organization can view it.
    # This checks if the user has *any* of the defined roles scoped to the record (the organization).
    user.has_role?(MEMBER_ROLES, record)
  end

  # --- Creation ---

  def create?
    # Only users who are logged in can create a new organization.
    user.present?
  end

  # --- Modification and Deletion ---

  def update?
    # Only organization owners and admins can update the organization's details.
    # This checks if the user has *one of* the roles in the ADMIN_ROLES array, scoped to the record.
    user.has_role?(ADMIN_ROLES, record)
  end

  def destroy?
    # Only the owner of the organization can delete it.
    user.has_role?(OWNER_ROLES, record)
  end

  # --- Policy Scope (for index queries) ---

  class Scope < Scope
    def resolve
      user.organizations
    end
  end
end
