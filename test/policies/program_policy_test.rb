require "test_helper"

class ProgramPolicyTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @program = programs(:one)
    @user = users(:lazaro_nixon)

    # Set up user as organization admin for testing
    @user.add_role(:admin, @organization)
  end

  teardown do
    # Clean up roles after each test
    @user.roles.destroy_all
  end

  def test_show_as_program_member
    @user.add_role(:member, @program)
    assert ProgramPolicy.new(@user, @program).show?
  end

  def test_show_as_organization_admin
    # User is already organization admin from setup
    assert ProgramPolicy.new(@user, @program).show?
  end

  def test_show_unauthorized
    @user.roles.destroy_all # Remove admin role
    refute ProgramPolicy.new(@user, @program).show?
  end

  def test_create_as_organization_admin
    new_program = @organization.programs.build(name: "New Program")
    assert ProgramPolicy.new(@user, new_program).create?
  end

  def test_create_as_organization_owner
    @user.roles.destroy_all
    @user.add_role(:owner, @organization)
    new_program = @organization.programs.build(name: "New Program")
    assert ProgramPolicy.new(@user, new_program).create?
  end

  def test_create_unauthorized
    @user.roles.destroy_all
    new_program = @organization.programs.build(name: "New Program")
    refute ProgramPolicy.new(@user, new_program).create?
  end

  def test_update_as_program_admin
    @user.roles.destroy_all
    @user.add_role(:admin, @program)
    assert ProgramPolicy.new(@user, @program).update?
  end

  def test_update_as_organization_admin
    # User is already organization admin from setup
    assert ProgramPolicy.new(@user, @program).update?
  end

  def test_update_unauthorized
    @user.roles.destroy_all
    @user.add_role(:member, @program)
    refute ProgramPolicy.new(@user, @program).update?
  end

  def test_destroy_as_program_owner
    @user.roles.destroy_all
    @user.add_role(:owner, @program)
    assert ProgramPolicy.new(@user, @program).destroy?
  end

  def test_destroy_as_organization_admin
    # User is already organization admin from setup
    assert ProgramPolicy.new(@user, @program).destroy?
  end

  def test_destroy_as_organization_owner
    @user.roles.destroy_all
    @user.add_role(:owner, @organization)
    assert ProgramPolicy.new(@user, @program).destroy?
  end

  def test_destroy_unauthorized
    @user.roles.destroy_all
    @user.add_role(:member, @program)
    refute ProgramPolicy.new(@user, @program).destroy?
  end
end
