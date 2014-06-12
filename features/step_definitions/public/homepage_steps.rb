When(/^I visit the homepage$/) do
  visit root_path
end

Then(/^I should see a login link$/) do
  expect(page).to have_link("Log in")
end