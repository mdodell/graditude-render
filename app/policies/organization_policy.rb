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
    MEMBER_ROLES.any? { |role| user.has_role?(role, record) }
  end

  def create?
    user.present?
  end

  def update?
    ADMIN_ROLES.any? { |role| user.has_role?(role, record) }
  end

  def destroy?
    OWNER_ROLES.any? { |role| user.has_role?(role, record) }
  end

  # --- Policy Scope (for index queries) ---

  class Scope < Scope
    def resolve
      user.organizations
    end
  end
end
