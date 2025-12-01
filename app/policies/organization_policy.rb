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
    user.present? # Only authenticated users can update organizations
  end

  def destroy?
    user.present? # Only authenticated users can delete organizations
  end

  def invite_users?
    user.present? # Only authenticated users can invite users
  end

  def manage_members?
    user.present? # Only authenticated users can manage members
  end

  def view_members?
    user.present? # Only authenticated users can view members
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all # For now, show all organizations. Could be filtered by membership later
    end
  end
end
