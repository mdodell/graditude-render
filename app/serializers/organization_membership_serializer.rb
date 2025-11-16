class OrganizationMembershipSerializer < BaseSerializer
  attributes :id, :joined_at, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :organization, serializer: OrganizationSerializer
  belongs_to :invitation, serializer: InvitationSerializer, optional: true

  def role
    object.user.role_in(object.organization)
  end

  def invitation_status
    return "member" unless object.invitation
    return "pending" if object.invitation.pending?
    return "accepted" if object.invitation.accepted?
    nil
  end

  def invited_at
    object.invitation&.created_at || object.joined_at
  end
end
