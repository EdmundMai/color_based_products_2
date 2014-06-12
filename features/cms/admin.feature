Feature: Admin section

	Scenario: Visiting the admin homepage as a regular customer
		Given I am an authenticated customer
		When I visit the admin homepage
		Then I should be redirected back to the homepage
		
	Scenario Outline: Visiting different CMS sections as a regular customer
		Given I am an authenticated customer
		When I visit the admin <section> homepage
		Then I should be redirected back to the homepage
		
		Examples:
			|     section       |
			|     products      |
			|     file_uploads  |

	Scenario: Visiting the admin homepage
		Given I am an authenticated admin user
		When I visit the admin homepage
		Then I should see the admin homepage
		