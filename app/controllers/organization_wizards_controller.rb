class OrganizationWizardsController < InertiaController
  include Wicked::Wizard

  steps :details, :college, :description, :review

  before_action :set_organization, only: [ :show, :update ]

  # Ensure we start from the beginning
  before_action :ensure_wizard_start, only: [ :show ]

  def show
    case step
    when :details
      render inertia: "Organization/New", props: {
        organization: @organization,
        step: step.to_s
      }.merge(inertia_errors(@organization))
    when :college
      search_query = params[:search]
      colleges_query = College.all.order(:name)

      if search_query.present?
        colleges_query = colleges_query.where("name ILIKE ?", "%#{search_query}%")
      end

      @pagy, @colleges = pagy(colleges_query, items: 10)
      render inertia: "Organization/New", props: {
        organization: @organization,
        colleges: @colleges,
        pagy: @pagy,
        step: step.to_s
      }.merge(inertia_errors(@organization))
    when :description
      render inertia: "Organization/New", props: {
        organization: @organization,
        step: step.to_s
      }.merge(inertia_errors(@organization))
    when :review
      render inertia: "Organization/New", props: {
        organization: @organization,
        step: step.to_s
      }.merge(inertia_errors(@organization))
    end
  end

  def update
    case step
    when :details
      @organization.assign_attributes(organization_params)
      if @organization.valid?(:details)
        session[:organization_data] = @organization.attributes.to_json
        redirect_to next_wizard_path
      else
        render inertia: "Organization/New", props: {
          organization: @organization,
          step: step.to_s
        }.merge(inertia_errors(@organization)), status: :unprocessable_entity
      end
    when :college
      @organization.assign_attributes(organization_params)
      if @organization.valid?(:college)
        session[:organization_data] = @organization.attributes.to_json
        redirect_to next_wizard_path
      else
        @colleges = College.all
        render inertia: "Organization/New", props: {
          organization: @organization,
          colleges: @colleges,
          step: step.to_s
        }.merge(inertia_errors(@organization)), status: :unprocessable_entity
      end
    when :description
      @organization.assign_attributes(organization_params)
      if @organization.valid?(:description)
        session[:organization_data] = @organization.attributes.to_json
        redirect_to next_wizard_path
      else
        render inertia: "Organization/New", props: {
          organization: @organization,
          step: step.to_s
        }.merge(inertia_errors(@organization)), status: :unprocessable_entity
      end
    when :review
      # Assign the college_ids from the form data
      @organization.assign_attributes(organization_params)

      if @organization.save
        # Associate the selected colleges with the organization
        if organization_params[:college_ids].present?
          @organization.college_ids = organization_params[:college_ids]
        end

        session[:organization_data] = nil
        redirect_to @organization, notice: "Organization was successfully created."
      else
        render inertia: "Organization/New", props: {
          organization: @organization,
          step: step.to_s
        }.merge(inertia_errors(@organization)), status: :unprocessable_entity
      end
    end
  end

  def new
    # Clear any existing session data to start fresh
    session[:organization_data] = nil
    session[:organization_id] = nil

    @organization = Organization.new
    redirect_to wizard_path(steps.first)
  end


  private

  def set_organization
    if session[:organization_id]
      @organization = Organization.find(session[:organization_id])
    elsif session[:organization_data]
      @organization = Organization.new(JSON.parse(session[:organization_data]))
    else
      @organization = Organization.new
    end
  end

  def organization_params
    params.require(:organization).permit(:name, :domain, :description, college_ids: [])
  end

  def ensure_wizard_start
    # If we're not on the first step and there's no session data, redirect to first step
    if step != steps.first && session[:organization_data].blank? && session[:organization_id].blank?
      redirect_to wizard_path(steps.first)
    end
  end
end
