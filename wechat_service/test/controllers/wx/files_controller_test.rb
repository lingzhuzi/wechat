require 'test_helper'

class Wx::FilesControllerTest < ActionController::TestCase
  setup do
    @wx_file = wx_files(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wx_files)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wx_file" do
    assert_difference('Wx::File.count') do
      post :create, wx_file: { description: @wx_file.description, digest: @wx_file.digest, file_name: @wx_file.file_name, file_size: @wx_file.file_size, mime_type: @wx_file.mime_type }
    end

    assert_redirected_to wx_file_path(assigns(:wx_file))
  end

  test "should show wx_file" do
    get :show, id: @wx_file
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wx_file
    assert_response :success
  end

  test "should update wx_file" do
    patch :update, id: @wx_file, wx_file: { description: @wx_file.description, digest: @wx_file.digest, file_name: @wx_file.file_name, file_size: @wx_file.file_size, mime_type: @wx_file.mime_type }
    assert_redirected_to wx_file_path(assigns(:wx_file))
  end

  test "should destroy wx_file" do
    assert_difference('Wx::File.count', -1) do
      delete :destroy, id: @wx_file
    end

    assert_redirected_to wx_files_path
  end
end
