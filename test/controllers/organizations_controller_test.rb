require "test_helper"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
    @user = users(:lazaro_nixon)
    sign_in_as(@user)

    # Add user as owner to have full permissions
    @user.add_role(:owner, @organization)
  end

  teardown do
    @user.roles.destroy_all
  end

  test "should get new" do
    get new_organization_url
    assert_redirected_to "/organizations/new/details"
  end

  test "should show organization" do
    get organization_url(@organization)
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_url(@organization)
    assert_response :success
  end

  test "should update organization" do
    patch organization_url(@organization), params: { organization: { description: @organization.description, domain: @organization.domain, name: @organization.name } }
    assert_redirected_to organization_url(@organization)
  end

  test "should destroy organization" do
    assert_difference("Organization.count", -1) do
      delete organization_url(@organization)
    end

    assert_redirected_to organizations_url
  end
end
