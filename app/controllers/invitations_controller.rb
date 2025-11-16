class InvitationsController < ApplicationController
  before_action :authenticate
  before_action :set_invitation, only: [ :destroy ]
  before_action :set_invitable, only: [ :create ]

  def create
    @invitation = @invitable.invitations.build(invitation_params)
    authorize @invitation

    if @invitation.save
      # TODO: Send invitation email
      render json: InvitationSerializer.new(@invitation), status: :created
    else
      render json: { errors: @invitation.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @invitation

    @invitation.destroy
    redirect_back_or_to(root_path, notice: "Invitation to #{@invitation.email} has been deleted.")
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_invitable
    @invitable = params[:invitable_type].constantize.find(params[:invitable_id])
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
