Feature: Producing a fasta view of a genome scaffold
  In order to have generate a fasta file of a genome scaffold
  A user can use the "view fasta" plugin
  to generate a fasta file

  @disable-bundler
  Scenario: Getting the man page for the genomer view plugin
    Given I create a new genomer project
     When I run `genomer man view fasta`
     Then the exit status should be 0
      And the output should contain a valid man page
      And the output should contain "GENOMER-VIEW-FASTA(1)"
