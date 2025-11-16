class InvitationAcceptanceController < InertiaController
  before_action :authenticate
  before_action :set_invitation

  def update
    if @invitation.nil?
      redirect_back_or_to(root_path, alert: "Invitation code could not be found.")
    end

    # Authorization checks expired, accepted, and already_member conditions
    authorize @invitation, :accept?

    success = @invitation.accept!(Current.user)

    if success
      redirect_to @invitation.invitable,
        notice: "Successfully joined #{@invitation.invitable.class.name.downcase}"
    else
      redirect_back_or_to(root_path, inertia: inertia_errors(@invitation))
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find_by(invite_code: params[:invite_code])
  end
end
