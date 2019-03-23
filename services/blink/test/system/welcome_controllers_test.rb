require "application_system_test_case"

class WelcomeControllersTest < ApplicationSystemTestCase
  setup do
    @welcome_controller = welcome_controllers(:one)
  end

  test "visiting the index" do
    visit welcome_controllers_url
    assert_selector "h1", text: "Welcome Controllers"
  end

  test "creating a Welcome controller" do
    visit welcome_controllers_url
    click_on "New Welcome Controller"

    click_on "Create Welcome controller"

    assert_text "Welcome controller was successfully created"
    click_on "Back"
  end

  test "updating a Welcome controller" do
    visit welcome_controllers_url
    click_on "Edit", match: :first

    click_on "Update Welcome controller"

    assert_text "Welcome controller was successfully updated"
    click_on "Back"
  end

  test "destroying a Welcome controller" do
    visit welcome_controllers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Welcome controller was successfully destroyed"
  end
end
