Given(/^I am an authenticated admin user$/) do
  user = FactoryGirl.create(:admin_user)
  visit new_user_session_path
  fill_in("user[email]", with: user.email)
  fill_in("user[password]", with: "test123")
  check("user[remember_me]")
  click_button("Sign in")
end

When(/^I visit the admin homepage$/) do
  visit admin_path
end

When(/^I visit the admin (.*) homepage$/) do |section|
  path = "admin_#{section}_path"
  visit send(path)
end

Then(/^I should see the admin homepage$/) do
  user = User.last
  
  expect(current_path).to eq(admin_path)
  expect(page).to have_content("Admin Homepage")
  expect(page).to have_link("Products")
  expect(page).to have_link("Upload Files")
end