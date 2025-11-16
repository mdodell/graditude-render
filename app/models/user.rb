class User < ApplicationRecord
  rolify

  has_secure_password

  generates_token_for :email_verification, expires_in: 2.days do
    email
  end

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt.last(10)
  end

  has_many :sessions, dependent: :destroy
  has_many :invitations, foreign_key: "accepted_by_id", dependent: :nullify
  has_many :organization_memberships, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, allow_nil: true, length: { minimum: 12 }

  normalizes :email, with: -> { _1.strip.downcase }

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def organizations
    # Use memberships for efficient querying, but still check roles
    organization_memberships.includes(:organization).map(&:organization)
  end

  def member_of?(organization)
    organization_memberships.exists?(organization: organization) && (
      has_role?(:member, organization) || has_role?(:admin, organization) || has_role?(:owner, organization)
    )
  end

  def role_in(organization)
    return "owner" if has_role?(:owner, organization)
    return "admin" if has_role?(:admin, organization)
    return "member" if has_role?(:member, organization)
    nil
  end

  def membership_for(organization)
    organization_memberships.find_by(organization: organization)
  end
end
