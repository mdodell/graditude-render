require "test_helper"

class ProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:one)
    @program = programs(:one)
    @user = users(:lazaro_nixon)
    sign_in_as(@user)

    # Make user an organization admin to pass authorization
    @user.add_role(:admin, @organization)
  end

  teardown do
    @user.roles.destroy_all
  end

  test "should get index" do
    get organization_programs_url(@organization)
    assert_response :success
  end

  test "should get new" do
    get new_organization_program_url(@organization)
    assert_response :success
  end

  test "should create program" do
    assert_difference("Program.count") do
      post organization_programs_url(@organization), params: {
        program: {
          name: "New Test Program",
          description: "A new test program description"
        }
      }
    end

    assert_redirected_to organization_program_url(@organization, Program.last)
  end

  test "should not create program without name" do
    assert_no_difference("Program.count") do
      post organization_programs_url(@organization), params: {
        program: {
          description: "Description without name"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should show program" do
    get organization_program_url(@organization, @program)
    assert_response :success
  end

  test "should get edit" do
    get edit_organization_program_url(@organization, @program)
    assert_response :success
  end

  test "should update program" do
    patch organization_program_url(@organization, @program), params: {
      program: {
        name: "Updated Program Name",
        description: @program.description
      }
    }

    assert_redirected_to organization_program_url(@organization, @program)
  end

  test "should not update program with invalid data" do
    patch organization_program_url(@organization, @program), params: {
      program: {
        name: "" # Invalid - name can't be blank
      }
    }

    assert_response :unprocessable_entity
  end

  test "should destroy program" do
    # Make user an owner to pass destroy authorization
    @user.add_role(:owner, @organization)

    assert_difference("Program.count", -1) do
      delete organization_program_url(@organization, @program)
    end

    assert_redirected_to organization_programs_url(@organization)
  end

  test "should not allow unauthorized user to create program" do
    @user.roles.destroy_all # Remove admin role

    assert_no_difference("Program.count") do
      post organization_programs_url(@organization), params: {
        program: {
          name: "Unauthorized Program",
          description: "Should not be created"
        }
      }
    end

    assert_response :redirect
  end

  test "should not allow unauthorized user to update program" do
    @user.roles.destroy_all # Remove admin role

    patch organization_program_url(@organization, @program), params: {
      program: {
        name: "Unauthorized Update"
      }
    }

    assert_response :redirect
  end

  test "should not allow unauthorized user to destroy program" do
    @user.roles.destroy_all # Remove admin role

    assert_no_difference("Program.count") do
      delete organization_program_url(@organization, @program)
    end

    assert_response :redirect
  end
end
