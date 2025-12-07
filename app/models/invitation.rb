class Invitation < ApplicationRecord
  # 🌟 Reinstated Polymorphic Association
  # The 'invitable' entity is whatever the invitation is for.
  belongs_to :invitable, polymorphic: true

  # Define statuses
  enum :status, { pending: 0, accepted: 1, rejected: 2, cancelled: 3 }

  validates :token, presence: true, uniqueness: true
  validates :invitable, presence: true
end
