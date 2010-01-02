Feature: Extract Method
  In order to improve my code's quality
  As a developer
  I want to extract methods

  Scenario: Simple code, no variables, one method
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
          other_method()
        end

        def other_method()
          puts :code
          puts /to be/
          puts 'refactored'
        end
      """

  Scenario: Simple code, no variables, many methods
    Given I have the following code:
      """
        def the_method(firstArg, secondArg)
          puts :code
          puts /to be/
          puts 'refactored'
        end

        def more()
          n = 3+2/7
          puts "other #{n}"
          n
        end
      """
    And lines from 3 to 4 are selected
    And I want them to be in the method called 'new_method'
    When I call 'extract method'
    Then the code should be:
      """
        def the_method(firstArg, secondArg)
          puts :code
          new_method()
        end

        def new_method()
          puts /to be/
          puts 'refactored'
        end

        def more()
          n = 3+2/7
          puts "other #{n}"
          n
        end
      """
