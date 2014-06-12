Feature: File uploads


	Background:
		Given I am an authenticated admin user

	Scenario: Uploading a valid tax file
		Given New York State
		When I visit the admin file uploads index page
		And I upload a valid tax file
		Then tax rates should be updated
		
	Scenario: Uploading an invalid tax file
		Given New York State
		When I visit the admin file uploads index page
		And I upload an invalid tax file
		Then tax rates should not be updated