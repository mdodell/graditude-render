class OrganizationPolicy < ApplicationPolicy
  def index?
    true # Anyone can view the list of organizations
  end

  def show?
    true # Anyone can view organization details
  end

  def create?
    user.present? # Only authenticated users can create organizations
  end

  def update?
    owner_or_admin? # Only owners and admins can update organizations
  end

  def destroy?
    owner? # Only owners can delete organizations
  end

  def invite_users?
    owner_or_admin? # Only owners and admins can invite users
  end

  def manage_members?
    owner_or_admin? # Only owners and admins can manage members
  end

  def view_members?
    owner_admin_or_member? # Members can view other members
  end

  private

  # Organization-specific role helper methods
  def owner?
    user&.has_role?(:owner, record)
  end

  def admin?
    user&.has_role?(:admin, record)
  end

  def member?
    user&.has_role?(:member, record)
  end

  def owner_or_admin?
    owner? || admin?
  end

  def owner_admin_or_member?
    owner? || admin? || member?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all # For now, show all organizations. Could be filtered by membership later
    end
  end
end
