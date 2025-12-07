class ProgramsController < InertiaController
  before_action :set_organization
  before_action :set_program, only: %i[ show edit update destroy ]
  before_action :authenticate

  # GET /organizations/:organization_id/programs
  def index
    @programs = @organization.programs
    render inertia: "Program/Index", props: {
      organization: OrganizationSerializer.one(@organization),
      programs: ProgramSerializer.many(@programs)
    }
  end

  # GET /organizations/:organization_id/programs/:id
  def show
    authorize @program
    render inertia: "Program/Show", props: {
      organization: OrganizationSerializer.one(@organization),
      program: ProgramSerializer.one(@program)
    }
  end

  # GET /organizations/:organization_id/programs/new
  def new
    @program = @organization.programs.build
    authorize @program
    render inertia: "Program/New", props: {
      organization: OrganizationSerializer.one(@organization)
    }
  end

  # GET /organizations/:organization_id/programs/:id/edit
  def edit
    authorize @program
    render inertia: "Program/Edit", props: {
      organization: OrganizationSerializer.one(@organization),
      program: ProgramSerializer.one(@program)
    }
  end

  # POST /organizations/:organization_id/programs
  def create
    @program = @organization.programs.build(program_params)
    @program.created_by_user = Current.user
    authorize @program

    if @program.save
      redirect_to organization_program_path(@organization, @program), notice: "Program was successfully created."
    else
      render inertia: "Program/New", props: {
        organization: OrganizationSerializer.one(@organization),
        program: @program,
        errors: @program.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/:organization_id/programs/:id
  def update
    authorize @program

    if @program.update(program_params)
      redirect_to organization_program_path(@organization, @program), notice: "Program was successfully updated."
    else
      render inertia: "Program/Edit", props: {
        organization: OrganizationSerializer.one(@organization),
        program: @program,
        errors: @program.errors
      }, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/:organization_id/programs/:id
  def destroy
    authorize @program
    @program.destroy!
    redirect_to organization_programs_path(@organization), status: :see_other, notice: "Program was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:organization_id])
    end

    def set_program
      @program = @organization.programs.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def program_params
      params.require(:program).permit(:name, :description)
    end
end
