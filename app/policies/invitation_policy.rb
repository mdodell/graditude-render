class InvitationPolicy < ApplicationPolicy
  def show?
    # Can view invitation if they were invited (email matches)
    user.present? && record.email == user.email
  end

  def create?
    # Can create invitations for entities they can manage
    user.present? && can_manage_invitable?
  end

  def update?
    # Can update invitations for entities they can manage
    can_manage_invitable?
  end

  def destroy?
    # Can delete invitations for entities they can manage
    can_manage_invitable?
  end

  def accept?
    return false unless user.present?

    # Check conditions in priority order and capture failure reason
    @accept_failure_reason = check_accept_conditions
    @accept_failure_reason.nil?
  end

  def error_reason(query)
    return @accept_failure_reason if query == :accept? && instance_variable_defined?(:@accept_failure_reason)
    super
  end

  private

  def check_accept_conditions
    return :wrong_email if record.email != user.email
    return :expired if record.expired?
    return :already_accepted if record.accepted?
    return :already_member if already_member?

    nil
  end

  def can_manage_invitable?
    return false unless record.invitable

    case record.invitable
    when Organization
      user.has_role?(:owner, record.invitable) || user.has_role?(:admin, record.invitable)
    # Add other invitable types here as needed
    # when Project
    #   user.has_role?(:owner, record.invitable) || user.has_role?(:admin, record.invitable)
    else
      false
    end
  end

  def already_member?
    return false unless record.invitable

    case record.invitable
    when Organization
      record.invitable.organization_memberships.exists?(user: user)
    # Add other invitable types here as needed
    # when Project
    #   record.invitable.memberships.exists?(user: user)
    else
      false
    end
  end
end
