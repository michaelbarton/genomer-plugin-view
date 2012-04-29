Feature: Producing an agp view of a scaffold
  In order to produce submit an incomplete scaffold
  A user can use the "agp" command
  to generate an agp file of the scaffold

  @disable-bundler
  Scenario: A single contig scaffold
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
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	5	1	W	contig00001	1	5	+
     """
