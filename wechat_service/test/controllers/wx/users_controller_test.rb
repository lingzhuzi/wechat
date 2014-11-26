require 'test_helper'

class Wx::UsersControllerTest < ActionController::TestCase
  setup do
    @wx_user = wx_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wx_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wx_user" do
    assert_difference('Wx::User.count') do
      post :create, wx_user: { app_id: @wx_user.app_id, avatar_id: @wx_user.avatar_id, description: @wx_user.description, nick_name: @wx_user.nick_name, open_id: @wx_user.open_id, remark_name: @wx_user.remark_name }
    end

    assert_redirected_to wx_user_path(assigns(:wx_user))
  end

  test "should show wx_user" do
    get :show, id: @wx_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wx_user
    assert_response :success
  end

  test "should update wx_user" do
    patch :update, id: @wx_user, wx_user: { app_id: @wx_user.app_id, avatar_id: @wx_user.avatar_id, description: @wx_user.description, nick_name: @wx_user.nick_name, open_id: @wx_user.open_id, remark_name: @wx_user.remark_name }
    assert_redirected_to wx_user_path(assigns(:wx_user))
  end

  test "should destroy wx_user" do
    assert_difference('Wx::User.count', -1) do
      delete :destroy, id: @wx_user
    end

    assert_redirected_to wx_users_path
  end
end
