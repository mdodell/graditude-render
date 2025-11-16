class InvitationSerializer < BaseSerializer
  attributes :id, :email, :invite_code, :expires_at, :accepted_at, :created_at, :updated_at
  belongs_to :accepted_by, serializer: UserSerializer

  def invitable
    case object.invitable
    when Organization
      OrganizationSerializer.new(object.invitable)
    else
      object.invitable
    end
  end

  def expired?
    object.expired?
  end

  def accepted?
    object.accepted?
  end

  def pending?
    object.pending?
  end
end
