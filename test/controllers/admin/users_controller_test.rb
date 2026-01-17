require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @regular_user = users(:two)
    @suspended_user = users(:suspended)
  end

  # Authorization tests
  test "non-admin cannot access admin users index" do
    sign_in_as(@regular_user)
    get admin_users_path
    assert_redirected_to root_path
  end

  test "unauthenticated user cannot access admin users index" do
    get admin_users_path
    assert_redirected_to new_session_path
  end

  test "admin can access admin users index" do
    sign_in_as(@admin)
    get admin_users_path
    assert_response :success
  end

  # Index tests
  test "admin can see list of users" do
    sign_in_as(@admin)
    get admin_users_path
    assert_response :success
    assert_select "table tbody tr", minimum: 1
  end

  # Show tests
  test "admin can view user details" do
    sign_in_as(@admin)
    get admin_user_path(@regular_user)
    assert_response :success
  end

  # Update tests (admin toggle)
  test "admin can grant admin rights to user" do
    sign_in_as(@admin)
    patch admin_user_path(@regular_user, is_admin: true)
    assert_redirected_to admin_user_path(@regular_user)
    @regular_user.reload
    assert @regular_user.admin?
  end

  test "admin can revoke admin rights from user" do
    # First make the user an admin
    @regular_user.update!(is_admin: true)

    sign_in_as(@admin)
    patch admin_user_path(@regular_user, is_admin: false)
    assert_redirected_to admin_user_path(@regular_user)
    @regular_user.reload
    refute @regular_user.admin?
  end

  test "admin cannot change own admin rights" do
    sign_in_as(@admin)
    patch admin_user_path(@admin, is_admin: false)
    assert_redirected_to admin_user_path(@admin)
    @admin.reload
    assert @admin.admin?
  end

  # Suspend tests
  test "admin can suspend a user" do
    sign_in_as(@admin)
    patch suspend_admin_user_path(@regular_user)
    assert_redirected_to admin_user_path(@regular_user)
    @regular_user.reload
    assert @regular_user.suspended?
  end

  test "admin cannot suspend self" do
    sign_in_as(@admin)
    patch suspend_admin_user_path(@admin)
    assert_redirected_to admin_user_path(@admin)
    @admin.reload
    refute @admin.suspended?
  end

  # Unsuspend tests
  test "admin can unsuspend a user" do
    sign_in_as(@admin)
    patch unsuspend_admin_user_path(@suspended_user)
    assert_redirected_to admin_user_path(@suspended_user)
    @suspended_user.reload
    refute @suspended_user.suspended?
  end
end
