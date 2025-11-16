class OrganizationsController < InertiaController
  before_action :set_organization, only: %i[ show edit update destroy ]
  before_action :authenticate

  # GET /organizations or /organizations.json
  def index
    @organizations = Organization.all
    render inertia: "Organization/Index", props: {
      organizations: OrganizationSerializer.many(@organizations)
    }
  end

  # GET /organizations/1 or /organizations/1.json
  def show
    render inertia: "Organization/Show", props: {
      organization: OrganizationSerializer.one(@organization),
      invitations: InvitationSerializer.many(@organization.pending_invitations),
      user_role: Current.user&.role_in(@organization)
    }
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    authorize @organization
    render inertia: "Organization/New"
  end

  # GET /organizations/1/edit
  def edit
    authorize @organization
    render inertia: "Organization/Edit", props: {
      organization: @organization
    }
  end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)
    authorize @organization

    if @organization.save
      redirect_to @organization, notice: "Organization was successfully created."
    else
      render inertia: "Organization/New", props: {
        organization: @organization,
        errors: @organization.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    authorize @organization

    if @organization.update(organization_params)
      redirect_to @organization, notice: "Organization was successfully updated."
    else
      render inertia: "Organization/Edit", props: {
        organization: @organization,
        errors: @organization.errors
      }, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    authorize @organization
    @organization.destroy!
    redirect_to organizations_path, status: :see_other, notice: "Organization was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :domain, :description)
    end
end
