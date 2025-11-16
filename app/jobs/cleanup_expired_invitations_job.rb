class CleanupExpiredInvitationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    expired_count = Invitation.expired.count
    Invitation.expired.delete_all

    Rails.logger.info "Cleaned up #{expired_count} expired invitations"
  end
end
