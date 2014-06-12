Then(/^I should see that product's details$/) do
  product = Product.last
  
  expect(page).to have_content(product.name)
  expect(page).to have_content(product.long_description)
  expect(page).to have_content(product.vendor.name)
  expect(page).to have_content(product.shape.name)
  expect(page).to have_content(product.category.name)
  expect(page).to have_content(product.material.name)
end

Then(/^I should see an add to cart button$/) do
  expect(page).to have_button("Add to cart")
end