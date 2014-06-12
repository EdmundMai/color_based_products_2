Given(/^an existing active product with instock variants$/) do
  FactoryGirl.create(:complete_product, active: true)
end

When(/^I visit the product show page$/) do
  product = Product.last
  visit product_path(product)
end

When(/^I add that product to my cart$/) do
  first(:button, "Add to cart").click
end

Then(/^my cart should have one item$/) do
  user = User.last
  expect(user.cart.cart_items.count).to eq(1)
end

Then(/^the quantity of my cart item should be (\d+)$/) do |quantity|
  user = User.last
  expect(user.cart.cart_items.last.quantity).to eq(2)
end

Then(/^I should be on the shopping cart page$/) do
  expect(current_path).to eq(checkout_path)
end

Given(/^an existing item in my cart$/) do
  product = FactoryGirl.create(:complete_product, active: true)
  visit product_path(product)
  first(:button, "Add to cart").click
end

Then(/^there shouldn't be a form to create an account$/) do
  expect(page).not_to have_field("payment_info[email]")
  expect(page).not_to have_field("payment_info[create_an_account]")
  expect(page).not_to have_field("payment_info[password]")
end

When(/^I visit the shopping cart page$/) do
  visit checkout_path
end

When(/^I remove an item from my cart$/) do
  first(:link, "X").click
end

Then(/^my cart should have no items$/) do
  user = User.last
  expect(user.cart.cart_items).to be_empty
end

Then(/^I should see a "(.*?)" link$/) do |link_text|
  expect(page).to have_link(link_text)
end

When(/^I checkout$/) do
  click_link("Checkout")
end

When(/^I fill in the form to create a new account$/) do
  fill_in("payment_info[email]", with: "abc123@nettheory.com")
  expect(page).not_to have_field("payment_info[password]")
  check("Create an account")
  expect(page).to have_field("payment_info[password]")
  fill_in("payment_info[password]", with: "test123")
end

Given(/^an existing state$/) do
  FactoryGirl.create(:state)
end

Given(/^an existing New York state$/) do
  FactoryGirl.create(:new_york_state)
end

Given(/^an existing tax for zip code "(.*?)"$/) do |zip_code|
  FactoryGirl.create(:tax, zip_code: zip_code, state_id: State.new_york.id)
end

When(/^I fill in a valid shipping address$/) do
  fill_in("payment_info[shipping_address_first_name]", with: "Lorem")
  fill_in("payment_info[shipping_address_last_name]", with: "Ipsum")
  fill_in("payment_info[shipping_address_street_address]", with: "123 Fake Street")
  fill_in("payment_info[shipping_address_street_address2]", with: "12")
  fill_in("payment_info[shipping_address_city]", with: "New York")
  select(State.new_york.short_name, from: "payment_info[shipping_address_state_id]")
  fill_in("payment_info[shipping_address_zip_code]", with: Tax.last.zip_code)
  fill_in("payment_info[shipping_address_phone_number]", with: "1231231234")
end

When(/^I fill in a valid billing address$/) do
  fill_in("payment_info[billing_address_first_name]", with: "Lorem")
  fill_in("payment_info[billing_address_last_name]", with: "Ipsum")
  fill_in("payment_info[billing_address_street_address]", with: "123 Fake Street")
  fill_in("payment_info[billing_address_street_address2]", with: "12")
  fill_in("payment_info[billing_address_city]", with: "New York")
  select(State.new_york.short_name, from: "payment_info[billing_address_state_id]")
  fill_in("payment_info[billing_address_zip_code]", with: Tax.last.zip_code)
  fill_in("payment_info[billing_address_phone_number]", with: "1231231234")
end

When(/^I fill in a valid credit card$/) do
  fill_in("payment_info[credit_card_number]", with: "4111111111111111")
  select("12", from: "payment_info[credit_card_exp_mm]")
  select((Date.today.year + 1).to_s, from: "payment_info[credit_card_exp_yyyy]")
  fill_in("payment_info[credit_card_cvv]", with: "123")
end

When(/^I press "(.*?)"$/) do |button_text|
  click_button(button_text)
end

When(/^I submit my order$/) do
  click_button("Submit Order")
  sleep 2
end

Then(/^the review button should be enabled$/) do
  expect(find_button("Review")).not_to be_nil
end

Then(/^the submit order button should be disabled$/) do
  expect(find("#submit_order_button")[:disabled]).to be_true
end

Then(/^the edit button should be disabled$/) do
  expect(find("#edit_payment_info_button")[:disabled]).to be_true
end

When(/^I fill in the form to create a new account incorrectly$/) do
  check("Create an account")
end

When(/^I fill in a invalid shipping address$/) do
  select(State.new_york.short_name, from: "payment_info[shipping_address_state_id]")
end

When(/^I fill in a invalid billing address$/) do
  # do nothing
end

When(/^I fill in a invalid credit card$/) do
  # do nothing
end

Then(/^I should see errors for my payment info$/) do
  expect(page).to have_content("Password can't be blank")
  expect(page).to have_content("Shipping address first name can't be blank")
  expect(page).to have_content("Shipping address last name can't be blank")
  expect(page).to have_content("Shipping address street address can't be blank")
  expect(page).to have_content("Shipping address street address2 can't be blank")
  expect(page).to have_content("Shipping address zip code can't be blank")
  expect(page).to have_content("Shipping address city can't be blank")
  expect(page).to have_content("Shipping address phone number can't be blank")
  expect(page).to have_content("Billing address first name can't be blank")
  expect(page).to have_content("Billing address last name can't be blank")
  expect(page).to have_content("Billing address street address can't be blank")
  expect(page).to have_content("Billing address street address2 can't be blank")
  expect(page).to have_content("Billing address zip code can't be blank")
  expect(page).to have_content("Billing address city can't be blank")
  expect(page).to have_content("Billing address phone number can't be blank")
  expect(page).to have_content("Credit card number can't be blank")
  expect(page).to have_content("Credit card cvv can't be blank")
  expect(page).to have_content("The zip code you entered is invalid. Please try again.")
  expect(page).to have_content("Email is invalid")
  expect(page).to have_content("Email can't be blank")
end


Then(/^my order should be placed$/) do
  expect(Order.count).to eq(1)
  
  order = Order.last
  
  expect(order.status).to eq(Order::IN_PROGRESS)
  
  expect(order.shipping_address).not_to be_nil
  expect(order.shipping_address.first_name).to eq("Lorem")
  expect(order.shipping_address.last_name).to eq("Ipsum")
  expect(order.shipping_address.street_address).to eq("123 Fake Street")
  expect(order.shipping_address.street_address2).to eq("12")
  expect(order.shipping_address.state).to eq(State.new_york)
  expect(order.shipping_address.zip_code).to eq(Tax.last.zip_code)
  expect(order.shipping_address.phone_number).to eq("1231231234")

  expect(order.billing_address).not_to be_nil
  expect(order.shipping_address.first_name).to eq("Lorem")
  expect(order.shipping_address.last_name).to eq("Ipsum")
  expect(order.shipping_address.street_address).to eq("123 Fake Street")
  expect(order.shipping_address.street_address2).to eq("12")
  expect(order.shipping_address.state).to eq(State.new_york)
  expect(order.shipping_address.zip_code).to eq(Tax.last.zip_code)
  expect(order.shipping_address.phone_number).to eq("1231231234")
  
  expect(order.line_items).not_to be_empty
  line_item = order.line_items.last
  expect(line_item.quantity).to be == 1
  expect(line_item.unit_price).to be == Variant.last.price
end

Then(/^my guest cookie should be deleted$/) do
  if Capybara.current_session.driver.class == Capybara::Selenium::Driver
    expect(page.driver.browser.manage.cookie_named('guest_id')).to be_nil
  else
    expect(Capybara.current_session.driver.request.cookies.[]('guest_id')).to be_nil
  end
end

Then(/^my user should be updated$/) do
  order = Order.last
  user = order.user
  expect(user.email).to eq("abc123@nettheory.com")
  expect(user.guest?).to be_false
  expect(user.cart.cart_items).to be_empty
end