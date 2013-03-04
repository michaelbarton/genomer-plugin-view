Feature: Producing cds annotation view from a scaffold
  In order to submit CDS genome annotations
  A user can use the "table" command with --generate_encoded_features
  to generate the genbank annotation table format with CDS

  @disable-bundler
  Scenario: A CDS entry with no attributes
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
  Scenario: A CDS entry with a prefixed ID
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
     When I run `genomer view table --identifier=genome --generate_encoded_features=pre_`
     Then the exit status should be 0
      And the output should contain:
        """
        >Feature	genome	annotation_table
        3	1	gene
        			locus_tag	gene1
        3	1	CDS
        			protein_id	pre_gene1

        """

  @disable-bundler
  Scenario: A CDS entry with a Name attribute
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
        contig1	.	gene	4	6	.	+	1	ID=gene2;Name=defg
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
        4	6	gene
        			locus_tag	gene2
        			gene	defg
        4	6	CDS
        			protein_id	gene2
        			product	Defg

        """

  @disable-bundler
  Scenario: A CDS entry with a product attribute
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
        contig1	.	gene	4	6	.	+	1	ID=gene2;product=defg
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
        4	6	gene
        			locus_tag	gene2
        4	6	CDS
        			protein_id	gene2
        			product	defg

        """

  @disable-bundler
  Scenario: A CDS entry with Name and product attributes
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
        4	6	gene
        			locus_tag	gene2
        			gene	defg
        4	6	CDS
        			protein_id	gene2
        			product	Defg
        			function	xyz

        """

  @disable-bundler
  Scenario: A CDS entry with product and function attributes
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
        contig1	.	gene	4	6	.	+	1	ID=gene2;product=defg;function=xyz
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
        4	6	gene
        			locus_tag	gene2
        4	6	CDS
        			protein_id	gene2
        			product	defg
        			function	xyz

        """

  @disable-bundler
  Scenario: A CDS entry with Name, product and function attributes
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
        contig1	.	gene	4	6	.	+	1	ID=gene2;Name=abcd;product=efgh;function=ijkl
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
        4	6	gene
        			locus_tag	gene2
        			gene	abcd
        4	6	CDS
        			protein_id	gene2
        			product	Abcd
        			function	efgh

        """

  @disable-bundler
  Scenario: A CDS entry with ec_number and note attributes
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;ec_number=3.5.2.3;Note=my protein
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

        """

  @disable-bundler
  Scenario: A CDS entry with a single db_xref attribute
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
	contig1	.	gene	1	3	.	-	1	ID=gene1;db_xref=GO:000001
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
        			db_xref	GO:000001

        """

  @disable-bundler
  Scenario: A CDS entry with multiple db_xref attributes
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
	contig1	.	gene	1	3	.	-	1	ID=gene1;db_xref=GO:000001;db_xref=InterPro:IPR000111
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
        			db_xref	GO:000001
        			db_xref	InterPro:IPR000111
        """
