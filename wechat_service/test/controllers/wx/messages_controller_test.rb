require 'test_helper'

class Wx::MessagesControllerTest < ActionController::TestCase
  setup do
    @wx_message = wx_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wx_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wx_message" do
    assert_difference('Wx::Message.count') do
      post :create, wx_message: { content: @wx_message.content, create_time: @wx_message.create_time, from_user_name: @wx_message.from_user_name, message_type: @wx_message.message_type, msg_id: @wx_message.msg_id, to_user_name: @wx_message.to_user_name }
    end

    assert_redirected_to wx_message_path(assigns(:wx_message))
  end

  test "should show wx_message" do
    get :show, id: @wx_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wx_message
    assert_response :success
  end

  test "should update wx_message" do
    patch :update, id: @wx_message, wx_message: { content: @wx_message.content, create_time: @wx_message.create_time, from_user_name: @wx_message.from_user_name, message_type: @wx_message.message_type, msg_id: @wx_message.msg_id, to_user_name: @wx_message.to_user_name }
    assert_redirected_to wx_message_path(assigns(:wx_message))
  end

  test "should destroy wx_message" do
    assert_difference('Wx::Message.count', -1) do
      delete :destroy, id: @wx_message
    end

    assert_redirected_to wx_messages_path
  end
end
