class InvitationsController < InertiaController
  # Assume you have authentication set up
  before_action :authenticate

  # POST /organizations/1/invitations or /programs/1/invitations
  def create
    @invitable = find_invitable


    # Use bang method to raise an error if user doesn't exist
    invited_user = User.find_by(email: invitation_params[:email])

    if invited_user.blank?
      return redirect_to @invitable, alert: "User not found."
    end

    # 1. Determine the role to assign: use specified role or the resource's default
    role_to_assign = specified_role || default_role_for_invitable(@invitable)

    # 2. Prevent duplicate invites/membership
    if already_associated?(@invitable, invited_user)
      redirect_to @invitable, alert: "#{invited_user.email} is already associated with this #{@invitable.class.name}."
      return
    end

    ActiveRecord::Base.transaction do
      # Determine what the Invitation is actually linked to (Membership or the Resource itself)
      invitation_target = determine_invitation_target(@invitable, invited_user, role_to_assign)

      debugger
      # 3. Create the Invitation record linked polymorphically
      @invitation = invitation_target.create_invitation!(
        status: :pending,
        token: SecureRandom.urlsafe_base64(16)
      )
    end

    notice_message = "Invitation sent to #{invited_user.email}"
    notice_message += " as a '#{role_to_assign}'." if role_to_assign

    # Optional: Send Invitation Email
    # UserMailer.with(invitation: @invitation).invitation_email.deliver_later

    redirect_to @invitable, notice: notice_message
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User or resource not found."
  rescue StandardError => e
    redirect_to @invitable || root_path, alert: "Failed to create invitation: #{e.message}"
  end


  # PATCH /invitations/:token/accept
  def accept
    @invitation = Invitation.find_by!(token: params[:token], status: :pending)

    # Optional: Authentication check (e.g., if @invitation.user != current_user)

    if @invitation.accepted!
      # Execute any post-acceptance logic (e.g., mark Event as attended)
      handle_post_acceptance(@invitation)

      # Determine the redirect target (usually the parent resource of the invitable)
      target = @invitation.invitable.is_a?(Membership) ? @invitation.invitable.memberable : @invitation.invitable

      redirect_to target, notice: "You have successfully accepted the invitation!"
    else
      redirect_to root_path, alert: "Failed to accept the invitation."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Invalid or expired invitation link."
  end


  def show
    @invitation = Invitation.find_by!(token: params[:token], status: :pending)

    render inertia: { invitation: @invitation }
  end

  private

  # --- Polymorphism Handlers ---

  # Finds the resource instance (Organization, Program, or Event) from URL parameters
  def find_invitable
    # Add more invitable models here as needed
    %w[organization program event].each do |resource|
      if params["#{resource}_id"].present?
        # Capitalize and constantize the model name
        return resource.classify.constantize.find(params["#{resource}_id"])
      end
    end
    raise ActiveRecord::RecordNotFound, "Invitable resource not specified in the URL."
  end

  # --- Role/Association Handlers ---

  # Determines the specific role, prioritizing params over model default
  def default_role_for_invitable(invitable)
    # The invitable models (Organization, Program) should implement default_rolify_role
    if invitable.respond_to?(:default_rolify_role)
      return invitable.default_rolify_role
    end
    nil # Events might not have a role
  end

  # Returns the role name as a symbol if it is valid and permitted
  def specified_role
    role_param = invitation_params[:role_name]

    if role_param.present? && @invitable.respond_to?(:allowed_invitation_roles)
      role_sym = role_param.to_sym
      # Check against the allowed roles defined in the model/concern
      return role_sym if @invitable.class.allowed_invitation_roles.include?(role_sym)
    end
    nil
  end

  # Checks if the user is already associated with the invitable resource
  def already_associated?(invitable, user)
    # Rolify check for resources that use it (Organization/Program)
    if invitable.respond_to?(:default_rolify_role)
      return user.has_any_role?({ resource: invitable })
    end

    # Fallback for simple resources (e.g., Event)
    # return invitable.attendees.include?(user) if invitable.is_a?(Event)
    false
  end

  # --- Creation Logic ---

  # Determines whether the Invitation should link to the resource or a new Membership
  def determine_invitation_target(invitable, invited_user, role_to_assign)
    # If the resource defines a Rolify role, it's a long-term membership invite
    if invitable.respond_to?(:default_rolify_role)
      # 1. Create Membership
      membership = invitable.memberships.create!(user: invited_user)

      # 2. Assign Rolify role
      invited_user.add_role(role_to_assign, invitable)

      # The Invitation is for the Membership record
      membership
    else
      # If no Rolify role is present (e.g., Event), the Invitation is for the resource itself
      invitable
    end
  end

  # --- Acceptance Logic ---

  # Placeholder for actions needed after an invite is accepted
  def handle_post_acceptance(invitation)
    case invitation.invitable_type
    when "Membership"
      # Role/Membership is already established; no further action needed.
      nil
    when "Event"
      # e.g., Mark the user as confirmed/attending the event
      # invitation.invitable.attendees.create!(user: invitation.user)
      nil
    end
  end

  def invitation_params
    # Must permit :email and the user-specified :role_name
    params.require(:invitation).permit(:email, :role_name)
  end
end
