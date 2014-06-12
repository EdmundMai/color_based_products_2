Feature: Products
	
	Background:
		Given I am an authenticated admin user

	Scenario: Products index
		Given existing products
		When I visit the admin products index page
		Then I should see a list of products information
		
	@javascript
	Scenario: Creating a new product
		Given existing colors
		And existing vendors
		And existing shapes
		And existing categories
		And existing materials
		And existing sizes
		When I visit the admin products new page
		And I fill in the form to create a new product
		And I generate multiple variants
		And I submit the product form
		Then my product should be saved
		And I should be on the edit product page
	
	@javascript
	Scenario: Adding colors on the product form
		When I visit the admin products new page
		And I add a color
		Then that color should be available in the variant generator color form
	
	@javascript
	Scenario: Adding materials on the product form
		When I visit the admin products new page
		And I add a material
		Then that material should be available in the product form
		
	@javascript
	Scenario: Adding vendors on the product form
		When I visit the admin products new page
		And I add a vendor
		Then that vendor should be available in the the product form
		
	@javascript
	Scenario: Adding shapes on the product form
		When I visit the admin products new page
		And I add a shape
		Then that shape should be available in the the product form
		
	Scenario: Changing Men's and Women's sort orders
		Given an existing complete product
		When I visit the admin products edit page
		And I change the sort order for mens colors
		Then the sort orders for men's colors should be updated
		When I change the sort order for womens colors
		Then the sort orders for women's colors should be updated
	
	@javascript
	Scenario: Creating a new variant for an existing color
		Given an existing complete product
		When I visit the admin products edit page
		And I create a new variant for an existing color
		And I update my product
		Then my variant should be saved
	
	@javascript
	Scenario: Creating a new color
		Given existing products
		And existing sizes
		When I visit the admin products edit page
		And I create a new products color
		And I update my product
		Then my products color should be saved
		
	Scenario: Deleting a color
		Given an existing complete product
		When I visit the admin products edit page
		And I delete the last color
		Then that color should be deleted
		
	Scenario: Deleting a variant
		Given an existing complete product
		When I visit the admin products edit page
		And I delete the last variant of the last color
		Then that variant should be deleted
		
	Scenario: Deleting a product image
		Given an existing complete product
		When I visit the admin products edit page
		And I delete the last product image
		Then that image should be deleted
		
	@javascript
	Scenario: Adding a new variant to an existing color through the new color form
		Given an existing complete product
		And existing sizes
		When I visit the admin products edit page
		And I add a variant of a different size but with the same color
		And I update my product
		Then there should only be one product color of that color
		And that product color should have a new variant
		
	@javascript
	Scenario: Adding an existing variant to an existing color through the new color form
		Given an existing complete product
		And existing sizes
		When I visit the admin products edit page
		And I add a variant of the same size and color
		And I update my product
		Then there should only be one variant of that product color and size