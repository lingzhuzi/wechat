require 'test_helper'

class Wx::MessagesControllerTest < ActionController::TestCase
  setup do
    @message = wx_messages(:one)
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
      post :create, wx_message: { content: @message.content, create_time: @message.create_time, from_user_name: @message.from_user_name, message_type: @message.message_type, msg_id: @message.msg_id, to_user_name: @message.to_user_name }
    end

    assert_redirected_to wx_message_path(assigns(:wx_message))
  end

  test "should show wx_message" do
    get :show, id: @message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @message
    assert_response :success
  end

  test "should update wx_message" do
    patch :update, id: @message, wx_message: { content: @message.content, create_time: @message.create_time, from_user_name: @message.from_user_name, message_type: @message.message_type, msg_id: @message.msg_id, to_user_name: @message.to_user_name }
    assert_redirected_to wx_message_path(assigns(:wx_message))
  end

  test "should destroy wx_message" do
    assert_difference('Wx::Message.count', -1) do
      delete :destroy, id: @message
    end

    assert_redirected_to wx_messages_path
  end
end
