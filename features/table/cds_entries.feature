Feature: Producing cds annotation view from a scaffold
  In order to submit CDS genome annotations
  A user can use the "table" command with --generate_encoded_features
  to generate the genbank annotation table format with CDS

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
     When I run `genomer view table --identifier=genome --generate_encoded_features`
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
     When I run `genomer view table --identifier=genome --generate_encoded_features=pre_`
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
     When I run `genomer view table --identifier=genome --generate_encoded_features`
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

  @disable-bundler
  Scenario: CDS features with multiple attributes
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;ec_number=3.5.2.3;Note=my protein;function=catalysis
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --generate_encoded_features`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        3	1	gene
        			locus_tag	gene1
        3	1	CDS
        			protein_id	gene1
        			EC_number	3.5.2.3
        			note	my protein
        			function	catalysis

        """

