require 'test_helper'

class WelcomeControllersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @welcome_controller = welcome_controllers(:one)
  end

  test "should get index" do
    get welcome_controllers_url
    assert_response :success
  end

  test "should get new" do
    get new_welcome_controller_url
    assert_response :success
  end

  test "should create welcome_controller" do
    assert_difference('WelcomeController.count') do
      post welcome_controllers_url, params: { welcome_controller: {  } }
    end

    assert_redirected_to welcome_controller_url(WelcomeController.last)
  end

  test "should show welcome_controller" do
    get welcome_controller_url(@welcome_controller)
    assert_response :success
  end

  test "should get edit" do
    get edit_welcome_controller_url(@welcome_controller)
    assert_response :success
  end

  test "should update welcome_controller" do
    patch welcome_controller_url(@welcome_controller), params: { welcome_controller: {  } }
    assert_redirected_to welcome_controller_url(@welcome_controller)
  end

  test "should destroy welcome_controller" do
    assert_difference('WelcomeController.count', -1) do
      delete welcome_controller_url(@welcome_controller)
    end

    assert_redirected_to welcome_controllers_url
  end
end
