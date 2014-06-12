Feature: Products

	Scenario: Viewing a product
		Given an existing complete product
		When I visit the product show page
		Then I should see an add to cart button