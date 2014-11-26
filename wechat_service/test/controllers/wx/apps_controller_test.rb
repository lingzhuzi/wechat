require 'test_helper'

class Wx::AppsControllerTest < ActionController::TestCase
  setup do
    @wx_app = wx_apps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wx_apps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wx_app" do
    assert_difference('Wx::App.count') do
      post :create, wx_app: { app_id: @wx_app.app_id, icon_id: @wx_app.icon_id, name: @wx_app.name, sceret: @wx_app.sceret, wx_id: @wx_app.wx_id }
    end

    assert_redirected_to wx_app_path(assigns(:wx_app))
  end

  test "should show wx_app" do
    get :show, id: @wx_app
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wx_app
    assert_response :success
  end

  test "should update wx_app" do
    patch :update, id: @wx_app, wx_app: { app_id: @wx_app.app_id, icon_id: @wx_app.icon_id, name: @wx_app.name, sceret: @wx_app.sceret, wx_id: @wx_app.wx_id }
    assert_redirected_to wx_app_path(assigns(:wx_app))
  end

  test "should destroy wx_app" do
    assert_difference('Wx::App.count', -1) do
      delete :destroy, id: @wx_app
    end

    assert_redirected_to wx_apps_path
  end
end
