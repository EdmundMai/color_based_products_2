
Given(/^New York State$/) do
  FactoryGirl.create(:state, short_name: "NY", long_name: "New York")
end

When(/^I visit the admin file uploads index page$/) do
  visit admin_file_uploads_path
end

When(/^I upload a valid tax file$/) do
  attach_file('Tax rates', File.join(Rails.root, 'spec', 'support', 'tax_rates.txt'))
  click_button "Update Taxes"
end

Then(/^tax rates should be updated$/) do
  expect(page).to have_content("Tax rate file is now being processed.")
  expect(Tax.count).not_to eq(0)
end

When(/^I upload an invalid tax file$/) do
  attach_file('Tax rates', File.join(Rails.root, 'spec', 'support', 'sample_img.jpg'))
  click_button "Update Taxes"
end

Then(/^tax rates should not be updated$/) do
  expect(page).to have_content("There was something wrong with your file. Please try again.")
  expect(Tax.count).to eq(0)
end