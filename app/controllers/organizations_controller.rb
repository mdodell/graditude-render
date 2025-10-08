class OrganizationsController < InertiaController
  before_action :set_organization, only: %i[ show edit update destroy ]

  # GET /organizations or /organizations.json
  def index
    @organizations = Organization.all
    render inertia: "Organization/Index", props: {
      organizations: @organizations
    }
  end

  # GET /organizations/1 or /organizations/1.json
  def show
    render inertia: "Organization/Show", props: {
      organization: @organization
    }
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    render inertia: "Organization/New"
  end

  # GET /organizations/1/edit
  def edit
    render inertia: "Organization/Edit", props: {
      organization: @organization
    }
  end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)

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
    @organization.destroy!
    redirect_to organizations_path, status: :see_other, notice: "Organization was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :domain, :description)
    end
end
