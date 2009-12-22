Feature: Extract Variable
  In order to improve my code's quality
  As a developer
  I want to extract variables

  Scenario: Extracting a variable
    Given I have the following code:
      """
        def method
          puts "string" + "other"
        end
      """
    And text '"string"' from line 2 is selected
    And I want it to be in the variable called 'var'
    When I call 'extract variable'
    Then the code should be:
      """
        def method
          var = "string"
          puts var + "other"
        end
      """

  Scenario: Extracting a variable on multiple occurrences
    Given I have the following code:
      """
        def method
          puts "string" + "other"
          puts "string" + "another"
        end
      """
    And text '"string"' from line 2 is selected
    And I want it to be in the variable called 'var'
    When I call 'extract variable'
    Then the code should be:
      """
        def method
          var = "string"
          puts var + "other"
          puts var + "another"
        end
      """
      
  Scenario: Extracting a variable just in the current method
    Given I have the following code:
      """
        def method
          puts "string" + "other"
        end
        
        def other_method
          puts "string" + "other"
        end
      """
    And text '"string"' from line 2 is selected
    And I want it to be in the variable called 'var'
    When I call 'extract variable'
    Then the code should be:
      """
        def method
          var = "string"
          puts var + "other"
        end
        
        def other_method
          puts "string" + "other"
        end
      """