class Organization < ApplicationRecord
  resourcify

  has_and_belongs_to_many :colleges, join_table: :organization_colleges, dependent: :delete_all
  has_many :invitations, as: :invitable, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy

  # Clean up roles when organization is destroyed
  before_destroy :cleanup_roles

  # Callback to create membership when user is added to organization
  after_create :create_membership_for_owner

  # Helper method to add user with automatic membership creation
  def add_member!(user, role: :member, invited_by: nil)
    transaction do
      # Add rolify role
      user.add_role(role, self)

      # Create membership (or update if exists)
      membership = organization_memberships.find_or_initialize_by(user: user)
      if membership.new_record?
        membership.joined_at = Time.current
        membership.invited_at = invited_by ? Time.current : nil
        membership.save!
      end

      membership
    end
  end

  # Step validations for wicked wizard
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, on: :details
  validates :domain, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/ }, on: :details

  validate :must_have_college, on: :college

  validates :description, length: { maximum: 250 }, on: :description

  scope :with_colleges, -> { joins(:colleges).distinct }
  scope :without_colleges, -> { left_joins(:colleges).where(colleges: { id: nil }) }
  scope :by_college, ->(college) { joins(:colleges).where(colleges: { id: college.id }) }

  def users
    User.with_role(:member, self) + User.with_role(:admin, self) + User.with_role(:owner, self)
  end

  def owners
    User.with_role(:owner, self)
  end

  def admins
    User.with_role(:admin, self)
  end

  def members
    User.with_role(:member, self)
  end

  def invite_user!(email, invited_by:)
    return false if users.any? { |user| user.email == email }

    invitations.create!(
      email: email
    )
  end

  def pending_invitations
    invitations.active
  end

  # Membership helpers - combines rolify roles with membership join table
  def memberships_with_details
    organization_memberships.includes(:user, :invitation).map do |membership|
      {
        membership: membership,
        user: membership.user,
        role: membership.role,
        joined_at: membership.joined_at,
        invited_at: membership.invitation&.created_at || membership.joined_at,
        invitation: membership.invitation,
        invitation_status: membership.invitation&.pending? ? "pending" : membership.invitation&.accepted? ? "accepted" : nil
      }
    end
  end

  # Get all members with their invitation status
  def members_with_invitation_status
    # Get all members via memberships
    members_with_details = organization_memberships.includes(:user, :invitation).map do |membership|
      {
        user: membership.user,
        role: membership.role,
        joined_at: membership.joined_at,
        invitation: membership.invitation,
        invitation_status: membership.invitation&.pending? ? "pending" : "member"
      }
    end

    # Get pending invitations for users who aren't members yet
    pending_invitations.reject do |invitation|
      members_with_details.any? { |m| m[:user].email.downcase == invitation.email.downcase }
    end.map do |invitation|
      {
        user: nil,
        email: invitation.email,
        role: nil,
        invitation: invitation,
        invitation_status: "invited"
      }
    end + members_with_details
  end

  private

  def cleanup_roles
    # Remove all roles associated with this organization
    Role.where(resource: self).destroy_all
  end

  def must_have_college
    errors.add(:colleges, "must be selected") if colleges.empty?
  end

  def create_membership_for_owner
    return unless Current.user

    # Add rolify role
    Current.user.add_role(:owner, self)

    # Create membership record
    organization_memberships.create!(
      user: Current.user,
      joined_at: Time.current
    )
  end
end
