Feature: Producing a map of annotations IDs
  In order to use map annotation IDs between versions
  A user can use the "mapping" command
  to generate a list of the original and updated annotations

  @disable-bundler
  Scenario: Getting the man page for the genomer view plugin
    Given I create a new genomer project
     When I run `genomer man view mapping`
     Then the exit status should be 0
      And the output should contain a valid man page
      And the output should contain "GENOMER-VIEW-MAPPING(1)"

  @disable-bundler
  Scenario: Two genes with locus tag numbering reset at the scaffold origin
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	4	6	.	+	1	ID=gene2
        """
     When I run `genomer view mapping --reset_locus_numbering`
     Then the exit status should be 0
      And the output should contain:
        """
	gene1	000001
	gene2	000002
        """

  @disable-bundler
  Scenario: Two genes with locus tag numbering reset at specified start value
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	4	6	.	+	1	ID=gene2
        """
     When I run `genomer view mapping --reset_locus_numbering=5`
     Then the exit status should be 0
      And the output should contain:
        """
	gene1	000005
	gene2	000006
        """

  @disable-bundler
  Scenario: Four unordered genes with locus tag reset at the scaffold origin
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	10	12	.	+	1	ID=gene4
        contig1	.	gene	4	6	.	+	1	ID=gene2
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	7	9	.	+	1	ID=gene3
        """
     When I run `genomer view mapping --reset_locus_numbering`
     Then the exit status should be 0
      And the output should contain:
        """
	gene1	000001
	gene2	000002
	gene3	000003
	gene4	000004
        """

  @disable-bundler
  Scenario: Four genes with a prefix added to the locus tags
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	10	12	.	+	1	ID=gene4
        contig1	.	gene	4	6	.	+	1	ID=gene2
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	7	9	.	+	1	ID=gene3
        """
     When I run `genomer view mapping --prefix=pre_`
     Then the exit status should be 0
      And the output should contain:
        """
	gene1	pre_gene1
	gene2	pre_gene2
	gene3	pre_gene3
	gene4	pre_gene4
        """

  @disable-bundler
  Scenario: Four genes prefixes and locus tag reset at the scaffold origin
    Given I create a new genomer project
      And I write to "assembly/scaffold.yml" with:
        """
        ---
          - sequence:
              source: contig1
        """
      And I write to "assembly/sequence.fna" with:
        """
        >contig1
        AAAAATTTTTGGGGGCCCCC
        """
      And I write to "assembly/annotations.gff" with:
        """
        ##gff-version 3
        contig1	.	gene	10	12	.	+	1	ID=gene4
        contig1	.	gene	4	6	.	+	1	ID=gene2
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	7	9	.	+	1	ID=gene3
        """
	When I run `genomer view mapping --reset_locus_numbering=5 --prefix=pre_`
     Then the exit status should be 0
      And the output should contain:
        """
	gene1	pre_000005
	gene2	pre_000006
	gene3	pre_000007
	gene4	pre_000008
        """
