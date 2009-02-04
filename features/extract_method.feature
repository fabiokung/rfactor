Feature: Extract Method
  In order to improve my code's quality
  As a developer
  I want to extract methods

  Scenario: Simple code, no variables
    Given I have the following code:
      """
        def the_method(firstArg, secondArg)
          puts "some"
          puts :code
          puts /to be/
          puts 'refactored'
        end
      """
    And lines from 3 to 5 are selected
    And I want them to be in the method called 'other_method'
    When I call 'extract method'
    Then the code should be:
      """
        def the_method(firstArg, secondArg)
          puts "some"
        end

        def other_method()
          puts :code
          puts /to be/
          puts 'refactored'
        end

      """
