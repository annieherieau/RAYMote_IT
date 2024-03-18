require "application_system_test_case"

class WorkshopsTest < ApplicationSystemTestCase
  setup do
    @workshop = workshops(:one)
  end

  test "visiting the index" do
    visit workshops_url
    assert_selector "h1", text: "Workshops"
  end

  test "should create workshop" do
    visit workshops_url
    click_on "New workshop"

    fill_in "Description", with: @workshop.description
    fill_in "Name", with: @workshop.name
    fill_in "Price", with: @workshop.price
    click_on "Create Workshop"

    assert_text "Workshop was successfully created"
    click_on "Back"
  end

  test "should update Workshop" do
    visit workshop_url(@workshop)
    click_on "Edit this workshop", match: :first

    fill_in "Description", with: @workshop.description
    fill_in "Name", with: @workshop.name
    fill_in "Price", with: @workshop.price
    click_on "Update Workshop"

    assert_text "Workshop was successfully updated"
    click_on "Back"
  end

  test "should destroy Workshop" do
    visit workshop_url(@workshop)
    click_on "Destroy this workshop", match: :first

    assert_text "Workshop was successfully destroyed"
  end
end
