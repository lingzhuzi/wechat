require 'test_helper'

class Wx::KeyWordsControllerTest < ActionController::TestCase
  setup do
    @key_word = key_words(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:key_words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wx_key_word" do
    assert_difference('Wx::KeyWord.count') do
      post :create, wx_key_word: { app_id: @key_word.app_id, content: @key_word.content, key: @key_word.key }
    end

    assert_redirected_to wx_key_word_path(assigns(:wx_key_word))
  end

  test "should show wx_key_word" do
    get :show, id: @key_word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @key_word
    assert_response :success
  end

  test "should update wx_key_word" do
    patch :update, id: @key_word, wx_key_word: { app_id: @key_word.app_id, content: @key_word.content, key: @key_word.key }
    assert_redirected_to wx_key_word_path(assigns(:wx_key_word))
  end

  test "should destroy wx_key_word" do
    assert_difference('Wx::KeyWord.count', -1) do
      delete :destroy, id: @key_word
    end

    assert_redirected_to key_words_path
  end
end
