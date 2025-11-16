require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @owner = users(:lazaro_nixon)
    @owner.add_role(:owner, @organization)
  end

  def test_scope
    # All organizations should be visible
    policy = OrganizationPolicy::Scope.new(@owner, Organization)
    assert_includes policy.resolve, @organization
  end

  def test_show
    # Anyone can view organizations
    assert OrganizationPolicy.new(@owner, @organization).show?
    assert OrganizationPolicy.new(nil, @organization).show?
  end

  def test_create
    # Authenticated users can create organizations
    new_org = Organization.new
    assert OrganizationPolicy.new(@owner, new_org).create?
    refute OrganizationPolicy.new(nil, new_org).create?
  end

  def test_update
    # Owners can update organizations
    assert OrganizationPolicy.new(@owner, @organization).update?
  end

  def test_destroy
    # Only owners can destroy organizations
    assert OrganizationPolicy.new(@owner, @organization).destroy?
  end
end
