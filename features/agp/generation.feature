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

  @disable-bundler
  Scenario: A two contig scaffold
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      -
        sequence:
          source: "contig00002"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGGC
      >contig00002
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
     scaffold	6	10	2	W	contig00002	1	5	+
     """

  @disable-bundler
  Scenario: A single contig scaffold with a gap
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
      ATGNNNGCG
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
     scaffold	1	3	1	W	contig00001	1	3	+
     scaffold	4	6	2	N	contig	3	yes	<required>
     scaffold	7	9	3	W	contig00002	1	3	+
     """

  @disable-bundler
  Scenario: Two contigs scaffold containing gaps
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      -
        sequence:
          source: "contig00002"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGNNNGCG
      >contig00002
      ANG
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
     scaffold	1	3	1	W	contig00001	1	3	+
     scaffold	4	6	2	N	contig	3	yes	<required>
     scaffold	7	9	3	W	contig00002	1	3	+
     scaffold	10	10	4	W	contig00003	1	1	+
     scaffold	11	11	5	N	contig	1	yes	<required>
     scaffold	12	12	6	W	contig00004	1	1	+
     """
