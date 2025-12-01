require "test_helper"

class OrganizationPolicyTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @user = users(:lazaro_nixon)
  end

  def test_scope
    # All organizations should be visible
    policy = OrganizationPolicy::Scope.new(@user, Organization)
    assert_includes policy.resolve, @organization
  end

  def test_show
    # Anyone can view organizations
    assert OrganizationPolicy.new(@user, @organization).show?
    assert OrganizationPolicy.new(nil, @organization).show?
  end

  def test_create
    # Authenticated users can create organizations
    new_org = Organization.new
    assert OrganizationPolicy.new(@user, new_org).create?
    refute OrganizationPolicy.new(nil, new_org).create?
  end

  def test_update
    # Authenticated users can update organizations
    assert OrganizationPolicy.new(@user, @organization).update?
  end

  def test_destroy
    # Authenticated users can destroy organizations
    assert OrganizationPolicy.new(@user, @organization).destroy?
  end
end
