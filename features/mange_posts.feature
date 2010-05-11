Feature: Manage Posts
  In order to manage blog posts
  As an admin user
  I want to be able to create, edit, and delete posts
  
  Scenario: Post list
    Given I am logged in
    And I have posts titled Test1, Test2, Test3
    When I go to the list of posts
    Then I should see "Test1"
    And I should see "Test2"
    And I should see "Test3"
  
  Scenario: Edit post
    Given I am logged in
    And I have posts titled Test1
    When I visit the detail page for post "Test1"
    Then I should see "Test1" in the "title" field
    And I should see "Test post." in the "content" field

  Scenario: Delete post
    Given I am logged in
    And I have posts titled Test1, Test2, Test3
    When I visit the delete page for post "Test2"
    Then I should not see "Test2"
    And I should see "Test1"
    And I should see "Test3"