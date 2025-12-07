require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @user = users(:lazaro_nixon)
  end

  teardown do
    @user.roles.destroy_all
  end

  def test_scope
    # User should see organizations they belong to
    @organization.memberships.create!(user: @user)
    @user.add_role(:member, @organization)
    policy = OrganizationPolicy::Scope.new(@user, Organization)
    assert_includes policy.resolve, @organization
  end

  def test_show_as_member
    # Members can view the organization
    @user.add_role(:member, @organization)
    assert OrganizationPolicy.new(@user, @organization).show?
  end

  def test_show_unauthorized
    # Non-members cannot view the organization
    refute OrganizationPolicy.new(@user, @organization).show?
  end

  def test_create
    # Authenticated users can create organizations
    new_org = Organization.new
    assert OrganizationPolicy.new(@user, new_org).create?
    refute OrganizationPolicy.new(nil, new_org).create?
  end

  def test_update_as_admin
    # Admins can update organizations
    @user.add_role(:admin, @organization)
    assert OrganizationPolicy.new(@user, @organization).update?
  end

  def test_update_as_owner
    # Owners can update organizations
    @user.add_role(:owner, @organization)
    assert OrganizationPolicy.new(@user, @organization).update?
  end

  def test_update_unauthorized
    # Members cannot update organizations
    @user.add_role(:member, @organization)
    refute OrganizationPolicy.new(@user, @organization).update?
  end

  def test_destroy_as_owner
    # Owners can destroy organizations
    @user.add_role(:owner, @organization)
    assert OrganizationPolicy.new(@user, @organization).destroy?
  end

  def test_destroy_unauthorized
    # Admins and members cannot destroy organizations
    @user.add_role(:admin, @organization)
    refute OrganizationPolicy.new(@user, @organization).destroy?
  end
end
