Feature: Producing a fasta view of a scaffold
  In order to produce fasta output from a scaffold
  A user can use the "view" command
  to generate the required fasta output

  @disable-bundler
  Scenario: Generating fasta with the scaffolder-view-plugin
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGGC
      """
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-view', :path => '../../../'
      """
     When I run `genomer view fasta`
     Then the exit status should be 0
      And the output should contain:
     """
     >name
     ATGGC
     """
