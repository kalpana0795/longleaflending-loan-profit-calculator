require 'rails_helper'

RSpec.feature "Loan Profit Calculator", type: :feature, js: true do
  scenario "User successfully completes the multi-step form" do
    visit new_loan_profit_path

    # Step 1: Fill out target property and navigate to next step
    fill_in "Target Property*", with: "123 Main St, Springfield, IL"
    click_button "Next"

    # Step 2: Fill out loan term and navigate to next step
    fill_in "Loan Term*", with: "12"
    click_button "Next"

    # Step 3: Fill out purchase price and navigate to next step
    fill_in "Purchase Price*", with: "100000"
    click_button "Next"

    # Step 4: Fill out repair budget and navigate to next step
    fill_in "Estimated Repair Budget*", with: "5000"
    click_button "Next"

    # Step 5: Fill out after repair value and navigate to next step
    fill_in "After Repair Value*", with: "120000"
    click_button "Next"

    # Step 6: Fill out contact information and submit the form
    fill_in "First Name*", with: "John"
    fill_in "Last Name", with: "Doe"
    fill_in "Email*", with: "john.doe@example.com"
    fill_in "Phone Number*", with: "123-456-7890"
    click_button "Submit"

    # Assertion: Ensure the submission was successful
    expect(page).to have_content "Thanks, John Doe! Here are those figures we promised."
    expect(page).to have_content "And again, check your email for the Longleaf term sheet."
    expect(page).to have_content "Your Estimated Profit:"
    expect(page).to have_content "Return Rate:"
  end

  scenario "User attempts to navigate without filling required fields" do
    visit new_loan_profit_path

    # Attempt to move to the next step without filling out required fields
    click_button "Next"

    # Assertion: Ensure validation error messages are displayed
    expect(page).to have_content "This field is required.", count: 1

    # Fill out the first field and move to the next step
    fill_in "Target Property*", with: "123 Main St, Springfield, IL"
    click_button "Next"

    # Attempt to move to the next step without filling out the current required field
    click_button "Next"
    expect(page).to have_content "This field is required.", count: 1
  end
end
