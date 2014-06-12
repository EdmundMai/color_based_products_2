Given(/^I am an authenticated customer$/) do
  user = FactoryGirl.create(:user)
  visit new_user_session_path
  fill_in("user[email]", with: user.email)
  fill_in("user[password]", with: "test123")
  check("user[remember_me]")
  click_button("Sign in")
end

Then(/^I should be redirected back to the homepage$/) do
  expect(current_path).to eq(root_path)
end