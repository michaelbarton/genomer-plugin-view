Feature: Producing a annotation view of a scaffold
  In order to submit genome annotations
  A user can use the "table" command
  to generate the genbank annotation table format

  @disable-bundler
  Scenario: Generating a table file from a single annotation
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
     When I run `genomer view table --identifier=genome`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        1	3	gene

        """

  @disable-bundler
  Scenario: Generating a table file from two annotations
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
        contig1	.	gene	1	3	.	+	1	
        contig1	.	gene	4	6	.	+	1	
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        1	3	gene
        4	6	gene

        """

  @disable-bundler
  Scenario: Generating a table file from a gene with ID attribute
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
      contig1	.	gene	1	3	.	-	1	ID=gene1
      """
    And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-view', :path => '../../../'
      """
   When I run `genomer view table --identifier=genome`
   Then the exit status should be 0
    And the output should contain:
      """
      >Feature	genome	annotation_table
      3	1	gene
      			locus_tag	gene1

      """

  @disable-bundler
  Scenario: Generating a table file from a gene with ID and name attributes
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
      contig1	.	gene	1	3	.	-	1	ID=gene1;Name=abcd
      """
    And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-view', :path => '../../../'
      """
   When I run `genomer view table --identifier=genome`
   Then the exit status should be 0
    And the output should contain:
      """
      >Feature	genome	annotation_table
      3	1	gene
      			locus_tag	gene1
      			gene	abcd

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
     When I run `genomer view table --identifier=genome --reset_locus_numbering`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        1	3	gene
        			locus_tag	000001
        4	6	gene
        			locus_tag	000002

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
     When I run `genomer view table --identifier=genome --reset_locus_numbering`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        1	3	gene
        			locus_tag	000001
        4	6	gene
        			locus_tag	000002
        7	9	gene
        			locus_tag	000003
        10	12	gene
        			locus_tag	000004

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
        contig1	.	gene	10	12	.	+	1	ID=gene4
        contig1	.	gene	4	6	.	+	1	ID=gene2
        contig1	.	gene	1	3	.	+	1	ID=gene1
        contig1	.	gene	7	9	.	+	1	ID=gene3
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --prefix=pre_`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        1	3	gene
        			locus_tag	pre_gene1
        4	6	gene
        			locus_tag	pre_gene2
        7	9	gene
        			locus_tag	pre_gene3
        10	12	gene
        			locus_tag	pre_gene4

        """

  @disable-bundler
  Scenario: Creating a simple CDS entry from a gene entry
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
     When I run `genomer view table --identifier=genome --create_cds`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        1	3	gene
        1	3	CDS

        """

  @disable-bundler
  Scenario: Creating a CDS entry with a prefixed ID and Name attribute
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;Name=abcD
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --create_cds=pre_`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        3	1	gene
        			locus_tag	gene1
        			gene	abcD
        3	1	CDS
        			protein_id	pre_gene1
        			product	AbcD

        """

  @disable-bundler
  Scenario: Overwriting the CDS product field with the product attribute
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;product=abcd
        contig1	.	gene	4	6	.	+	1	ID=gene2;Name=defg;product=xyz
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --create_cds`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        3	1	gene
        			locus_tag	gene1
        3	1	CDS
        			protein_id	gene1
        			product	Abcd
        4	6	gene
        			locus_tag	gene2
        			gene	defg
        4	6	CDS
        			protein_id	gene2
        			product	Xyz

        """
