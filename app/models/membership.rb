class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :memberable, polymorphic: true

  has_one :invitation, as: :invitable, dependent: :destroy

  def invited?
    invitation.present?
  end

  def accepted?
    invitation&.accepted?
  end
end
