Feature: Producing an agp view of a scaffold
  In order to produce submit an incomplete scaffold
  A user can use the "agp" command
  to generate an agp file of the scaffold

  @disable-bundler
  Scenario: Getting the man page for the scaffold agp view
    Given I create a new genomer project
     When I run `genomer man view agp`
     Then the exit status should be 0
      And the output should contain a valid man page
      And the output should contain "GENOMER-VIEW-AGP(1)"

  @disable-bundler
  Scenario: A single contig scaffold
    Given I create a new genomer project
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
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	5	1	W	contig00001	1	5	+
     """

  @disable-bundler
  Scenario: A two contig scaffold
    Given I create a new genomer project
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
    Given I create a new genomer project
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
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	3	1	W	contig00001	1	3	+
     scaffold	4	6	2	N	3	scaffold	yes	internal
     scaffold	7	9	3	W	contig00002	1	3	+
     """

  @disable-bundler
  Scenario: Two contigs scaffold containing gaps
    Given I create a new genomer project
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
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	3	1	W	contig00001	1	3	+
     scaffold	4	6	2	N	3	scaffold	yes	internal
     scaffold	7	9	3	W	contig00002	1	3	+
     scaffold	10	10	4	W	contig00003	1	1	+
     scaffold	11	11	5	N	1	scaffold	yes	internal
     scaffold	12	12	6	W	contig00004	1	1	+
     """

  @disable-bundler
  Scenario: Two contigs separated by an unresolved region
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      -
        unresolved:
          length: 5
      -
        sequence:
          source: "contig00002"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGAT
      >contig00002
      ATGAT
      """
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	5	1	W	contig00001	1	5	+
     scaffold	6	10	2	N	5	scaffold	yes	specified
     scaffold	11	15	3	W	contig00002	1	5	+
     """

  @disable-bundler
  Scenario: Two contigs separated by an unresolved region
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
      -
        unresolved:
          length: 5
      -
        sequence:
          source: "contig00002"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGATNNNNN
      >contig00002
      ATGATNNNNN
      """
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	5	1	W	contig00001	1	5	+
     scaffold	6	10	2	N	5	scaffold	yes	internal
     scaffold	11	15	3	N	5	scaffold	yes	specified
     scaffold	16	20	4	W	contig00002	1	5	+
     scaffold	21	25	5	N	5	scaffold	yes	internal
     """

  @disable-bundler
  Scenario: A single contig scaffold with a gap filled with an insert
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
          inserts:
          -
            source: "insert00001"
            open: 4
            close: 6
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGNNNGCG
      >insert00001
      TTT
      """
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	9	1	W	contig00001	1	9	+
     """

  @disable-bundler
  Scenario: A single contig scaffold with a gap partially filled with an insert
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "contig00001"
          inserts:
          -
            source: "insert00001"
            open: 4
            close: 5
      """
      And I write to "assembly/sequence.fna" with:
      """
      >contig00001
      ATGNNNGCG
      >insert00001
      TTT
      """
     When I run `genomer view agp`
     Then the exit status should be 0
      And the output should contain:
     """
     ##agp-version	2.0
     scaffold	1	6	1	W	contig00001	1	6	+
     scaffold	7	7	2	N	1	scaffold	yes	internal
     scaffold	8	10	3	W	contig00002	1	3	+
     """

