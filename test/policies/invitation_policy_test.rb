require "test_helper"

class InvitationPolicyTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @owner = users(:lazaro_nixon)
    @owner.add_role(:owner, @organization)
    # Create membership record
    OrganizationMembership.create!(organization: @organization, user: @owner, joined_at: Time.current)
    @invitation = Invitation.create!(email: "test@example.com", invitable: @organization)
  end

  def test_create
    # Owners can create invitations
    new_invitation = Invitation.new(invitable: @organization)
    assert InvitationPolicy.new(@owner, new_invitation).create?
  end

  def test_update
    # Owners can update invitations
    assert InvitationPolicy.new(@owner, @invitation).update?
  end

  def test_destroy
    # Owners can destroy invitations
    assert InvitationPolicy.new(@owner, @invitation).destroy?
  end
end
