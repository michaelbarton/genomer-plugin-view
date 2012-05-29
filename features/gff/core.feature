Feature: Producing a gff3 view of a scaffold's annotations
  In order to view scaffold annotations
  A user can use the "gff" command
  to generate gff3 view of scaffold annotations

  @disable-bundler
  Scenario: A single annotation on a single contig
    Given I successfully run `genomer init project`
      And I cd to "project"
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
        contig1	.	gene	1	3	.	+	1	.
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view gff --identifier=genome`
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        genome	.	gene	1	3	.	+	1	.

        """

  @disable-bundler
  Scenario: Two annotations on a single contig
    Given I successfully run `genomer init project`
      And I cd to "project"
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
        contig1	.	gene	1	3	.	+	1	.
        contig1	.	gene	4	6	.	+	1	.
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view gff --identifier=genome`
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        genome	.	gene	1	3	.	+	1	.
        genome	.	gene	4	6	.	+	1	.

        """

  @disable-bundler
  Scenario: Reseting locus tag numbering at the scaffold origin
    Given I successfully run `genomer init project`
      And I cd to "project"
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
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view gff --identifier=genome --reset_locus_numbering`
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
	genome	.	gene	1	3	.	+	1	ID=000001
	genome	.	gene	4	6	.	+	1	ID=000002

        """
  @disable-bundler
  Scenario: Reseting locus tag numbering at specified start value
    Given I successfully run `genomer init project`
      And I cd to "project"
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
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view gff --identifier=genome --reset_locus_numbering=5`
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        genome	.	gene	1	3	.	+	1	ID=000005
        genome	.	gene	4	6	.	+	1	ID=000006

        """

  @disable-bundler
  Scenario: Reseting locus tag at the scaffold origin with unordered annotations
    Given I successfully run `genomer init project`
      And I cd to "project"
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
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view gff --identifier=genome --reset_locus_numbering`
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        genome	.	gene	1	3	.	+	1	ID=000001
        genome	.	gene	4	6	.	+	1	ID=000002
        genome	.	gene	7	9	.	+	1	ID=000003
        genome	.	gene	10	12	.	+	1	ID=000004

        """

  @disable-bundler
  Scenario: Adding a prefix to annotation locus tags
    Given I successfully run `genomer init project`
      And I cd to "project"
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
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view gff --identifier=genome --prefix=pre_`
     Then the exit status should be 0
      And the output should contain:
        """
        ##gff-version 3
        genome	.	gene	1	3	.	+	1	ID=pre_gene1
        genome	.	gene	4	6	.	+	1	ID=pre_gene2

        """


