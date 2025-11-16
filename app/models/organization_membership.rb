class OrganizationMembership < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  belongs_to :invitation, optional: true

  validates :joined_at, presence: true

  scope :owners, -> { joins(:user).merge(User.with_role(:owner, nil)) }
  scope :admins, -> { joins(:user).merge(User.where(id: User.with_role(:admin, nil) + User.with_role(:owner, nil))) }
  scope :members_only, -> { joins(:user).merge(User.with_role(:member, nil)) }

  # Helper methods to get role from associated rolify roles
  def role
    return "owner" if user.has_role?(:owner, organization)
    return "admin" if user.has_role?(:admin, organization)
    return "member" if user.has_role?(:member, organization)
    nil
  end

  def owner?
    user.has_role?(:owner, organization)
  end

  def admin?
    user.has_role?(:admin, organization)
  end

  def member?
    user.has_role?(:member, organization)
  end

  def pending_invitation?
    invitation.present? && invitation.pending?
  end

  # Get when the user was invited (from invitation or by another member)
  def invited_at
    invitation&.created_at || joined_at
  end
end
