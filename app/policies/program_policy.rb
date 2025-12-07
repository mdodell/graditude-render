# app/policies/program_policy.rb
class ProgramPolicy < ApplicationPolicy
  # Define constants for clarity
  OWNER_ROLES = [ :owner ].freeze
  ADMIN_ROLES = [ :admin, :owner ].freeze
  MEMBER_ROLES = [ :member, :admin, :owner ].freeze

  def index?
    user.present?
  end

  def show?
    program_member? || org_admin?
  end

  def create?
    user.present? && record.organization && org_admin?
  end

  def update?
    program_admin? || org_admin?
  end

  def destroy?
    program_owner? || org_admin?
  end

  private

  def program_member?
    MEMBER_ROLES.any? { |role| user.has_role?(role, record) }
  end

  def program_admin?
    ADMIN_ROLES.any? { |role| user.has_role?(role, record) }
  end

  def program_owner?
    OWNER_ROLES.any? { |role| user.has_role?(role, record) }
  end

  def org_admin?
    ADMIN_ROLES.any? { |role| user.has_role?(role, record.organization) }
  end
end
