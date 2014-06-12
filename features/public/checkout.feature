Feature: Checkout

	Scenario: Adding a product to my cart
		Given an existing active product with instock variants
		When I visit the product show page
		And I add that product to my cart
		Then my cart should have one item
		And I should be on the shopping cart page
		
	Scenario: Adding the same variant to my cart multiple times
		Given an existing active product with instock variants
		When I visit the product show page
		And I add that product to my cart
		And I visit the product show page
		And I add that product to my cart
		Then my cart should have one item
		And the quantity of my cart item should be 2
		
	Scenario: Removing a product from my cart
		Given an existing item in my cart
		When I visit the shopping cart page
		And I remove an item from my cart
		Then my cart should have no items
		And I should see a "Continue Shopping" link
		
	@javascript
	Scenario: Checkout out as a guest - Form errors on Review
		Given an existing state
		Given an existing New York state
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in the form to create a new account incorrectly
		And I fill in a invalid shipping address
		And I fill in a invalid billing address
		And I fill in a invalid credit card
		And I press "Review"
		Then I should see errors for my payment info
		And the review button should be enabled
		And the submit order button should be disabled
		And the edit button should be disabled
		
	@javascript
	Scenario: Checking out as a logged in user - Editing info after review
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I press "Edit"
		Then the review button should be enabled
		And the submit order button should be disabled
		
	@javascript
	Scenario: Checking out as a guest - Happy path
		Given an existing state
		Given an existing New York state
		And an existing tax for zip code "10001"
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		Then the review button should be enabled
		And the submit order button should be disabled
		And the edit button should be disabled
		And I fill in the form to create a new account
		And I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I submit my order
		Then my order should be placed
		And my user should be updated
		And my guest cookie should be deleted
		
	@javascript
	Scenario: Checking out as a logged in user - Happy path
		Given an existing state
		And an existing New York state
		And an existing tax for zip code "10001"
		And I am an authenticated customer
		And an existing item in my cart
		When I visit the shopping cart page
		And I checkout
		Then the review button should be enabled
		And the submit order button should be disabled
		And there shouldn't be a form to create an account
		When I fill in a valid shipping address
		And I fill in a valid billing address
		And I fill in a valid credit card
		And I press "Review"
		And I submit my order
		Then my order should be placed