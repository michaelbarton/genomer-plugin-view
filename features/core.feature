Feature: Producing different views of a genomes scaffold
  In order to have required file formats of a genome scaffold
  A user can use the "view" plugin
  to generate file formats

  @disable-bundler
  Scenario: Getting the man page for the genomer view plugin
    Given I create a new genomer project
     When I run `genomer man view`
     Then the exit status should be 0
      And the output should contain a valid man page
      And the output should contain "GENOMER-VIEW(1)"
