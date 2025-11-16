class Invitation < ApplicationRecord
  belongs_to :invitable, polymorphic: true
  belongs_to :accepted_by, class_name: "User", optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :invite_code, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validate :email_not_already_member
  validate :expires_at_in_future

  scope :pending, -> { where(accepted_at: nil) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :expired, -> { where("expires_at < ?", Time.current) }
  scope :active, -> { pending.where("expires_at > ?", Time.current) }

  before_validation :generate_invite_code, on: :create
  before_validation :set_expires_at, on: :create
  before_destroy :nullify_membership_references

  def expired?
    expires_at < Time.current
  end

  def accepted?
    accepted_at.present?
  end

  def pending?
    !accepted? && !expired?
  end

  def accept!(user)
    return false if expired? || accepted?

    transaction do
      # Mark invitation as accepted first
      update!(
        accepted_at: Time.current,
        accepted_by: user
      )

      # Add user to the invitable entity with member role using rolify
      user.add_role(:member, invitable)

      # Create membership record
      if invitable.is_a?(Organization)
        OrganizationMembership.create!(
          organization: invitable,
          user: user,
          invitation: self,
          joined_at: Time.current
        )
      end

      true
    end
  end

  private

  def generate_invite_code
    return if invite_code.present?

    loop do
      self.invite_code = SecureRandom.alphanumeric(12).upcase.scan(/.{1,4}/).join("-")
      break unless self.class.exists?(invite_code: invite_code)
    end
  end

  def set_expires_at
    self.expires_at ||= 72.hours.from_now
  end

  def email_not_already_member
    return unless invitable && email

    existing_user = User.find_by(email: email)
    if existing_user && existing_user.member_of?(invitable)
      errors.add(:email, "is already a member of this #{invitable.class.name.downcase}")
    end
  end

  def expires_at_in_future
    return unless expires_at

    errors.add(:expires_at, "must be in the future") if expires_at <= Time.current
  end

  def nullify_membership_references
    # Nullify foreign key references to avoid constraint violations
    OrganizationMembership.where(invitation_id: id).update_all(invitation_id: nil)
  end
end
