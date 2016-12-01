Feature: As an admin
  So that I can help members and create companies for them
  I need to be able to create companies

  PT:  https://www.pivotaltracker.com/story/show/133081453

  Background:
    Given the following users exists
      | email                      | admin |
      | applicant_1@happymutts.com |       |
      | admin@shf.se               | true  |

    And the following companies exist:
      | name                 | company_number | email                  |
      | No More Snarky Barky | 5560360793     | snarky@snarkybarky.com |

    And the following applications exist:
      | first_name | user_email                 | company_number | status   | category_name |
      | Emma       | applicant_1@happymutts.com | 5562252998     | approved | Awesome       |

    And the following business categories exist
      | name         |
      | Groomer      |
      | Psychologist |
      | Trainer      |
      | Awesome      |

  Scenario: Admin creates a company
    Given I am logged in as "admin@shf.se"
    When I am on the "create a new company" page
    And I fill in the form with data :
      | Name         | Organization Number | Street         | Post Code | City   | Region    | Email                | Website                   |
      | Glada Jyckar | 5562252998          | Ålstensgatan 4 | 123 45    | Bromma | Stockholm | kicki@gladajyckar.se | http://www.gladajyckar.se |
    And I select "Groomer" Category
    And I select "Trainer" Category
    And I click on "Submit"
    Then I should see "The company was successfully created."
    And I should see "Company: Glada Jyckar"
    And I should see "123 45"
    And I should see "Bromma"
    And I should see "Groomer"
    And I should see "Trainer"
    And I should not see "Awesome"


  Scenario Outline: Admin creates company - when things go wrong
    Given I am logged in as "admin@shf.se"
    When I am on the "create a new company" page
    And I fill in the form with data :
      | Name   | Organization Number | Email   | Phone Number | Street   | Post Code   | City   | Region   | Website   |
      | <name> | <org_number>        | <email> | <phone>      | <street> | <post_code> | <city> | <region> | <website> |
    When I click on "Submit"
    Then I should see <error>

    Scenarios:
      | name        | org_number | phone      | street         | post_code | city   | region    | email                | website                   | error                                                          |
      | Happy Mutts | 00         | 0706898525 | Ålstensgatan 4 | 123 45    | Bromma | Stockholm | kicki@gladajyckar.se | http://www.gladajyckar.se | "Company number is the wrong length (should be 10 characters)" |
      |             | 5562252998 |            | Ålstensgatan 4 | 123 45    | Bromma | Stockholm | kicki@gladajyckar.se | http://www.gladajyckar.se | "Name can't be blank"                                          |
      | Happy Mutts | 5562252998 |            | Ålstensgatan 4 | 123 45    | Bromma | Stockholm | kickiimmi.nu         | http://www.gladajyckar.se | "Email is invalid"                                             |
      | Happy Mutts | 5562252998 |            | Ålstensgatan 4 | 123 45    | Bromma | Stockholm | kicki@imminu         | http://www.gladajyckar.se | "Email is invalid"                                             |


  Scenario: User tries to create a company
    Given I am logged in as "applicant_1@happymutts.com"
    And I am on the "create a new company" page
    Then I should see "You are not authorized to perform this action"

  Scenario: User tries to view all companies
    Given I am logged in as "applicant_1@happymutts.com"
    And I am on the "all companies" page
    Then I should see "You are not authorized to perform this action"

  Scenario: Visitor tries to view all companies
    Given I am Logged out
    And I am on the "all companies" page
    Then I should see "You are not authorized to perform this action"

  Scenario: Visitor tries to create a company
    Given I am Logged out
    And I am on the "create a new company" page
    Then I should see "You are not authorized to perform this action"
