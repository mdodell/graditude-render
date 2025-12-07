require "test_helper"

class ProgramTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:one)
    @user = users(:lazaro_nixon)
    @program = programs(:one)
  end

  test "should belong to organization" do
    assert_equal @organization, @program.organization
  end

  test "should have memberships association" do
    assert_respond_to @program, :memberships
  end

  test "should have users association" do
    assert_respond_to @program, :users
  end

  test "should validate presence of name" do
    program = Program.new(organization: @organization, description: "Test")
    refute program.valid?
    assert_includes program.errors[:name], "can't be blank"
  end

  test "should validate presence of organization" do
    program = Program.new(name: "Test Program")
    refute program.valid?
    assert_includes program.errors[:organization], "can't be blank"
  end

  test "should validate name length" do
    program = Program.new(name: "A", organization: @organization)
    refute program.valid?
    assert_includes program.errors[:name], "is too short (minimum is 2 characters)"

    program.name = "A" * 101
    refute program.valid?
    assert_includes program.errors[:name], "is too long (maximum is 100 characters)"
  end

  test "should validate description length" do
    program = Program.new(name: "Valid Name", organization: @organization, description: "A" * 501)
    refute program.valid?
    assert_includes program.errors[:description], "is too long (maximum is 500 characters)"
  end

  test "default_rolify_role should return member" do
    assert_equal :member, @program.default_rolify_role
  end

  test "should set owner on create with created_by_user" do
    program = @organization.programs.create!(
      name: "New Program",
      description: "Test",
      created_by_user: @user
    )

    assert program.memberships.exists?(user: @user)
    assert @user.has_role?(:owner, program)
  end
end
