Feature: Producing an table view of alternate entries
  In order to submit non-CDS genome annotations
  A user can use the "table" command with --generate_encoded_features
  to generate the genbank annotation table format with non-CDS

  @disable-bundler
  Scenario: Creating a tRNA entry from using the 'feature_type' field
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;feature_type=tRNA;product=tRNA-Gly
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --generate_encoded_features`
     Then the exit status should be 0
      And the output should contain:
        """
        3	1	gene
        			locus_tag	gene1
        3	1	tRNA
        			product	tRNA-Gly

        """

  @disable-bundler
  Scenario: Creating a rRNA entry from using the 'feature_type' field
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;feature_type=rRNA;product=16S ribosomal RNA
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --generate_encoded_features`
     Then the exit status should be 0
      And the output should contain:
        """
        3	1	gene
        			locus_tag	gene1
        3	1	rRNA
        			product	16S ribosomal RNA

        """

  @disable-bundler
  Scenario: Creating a tmRNA entry from using the 'feature_type' field
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;feature_type=tmRNA;product=tmRNA
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --generate_encoded_features`
     Then the exit status should be 0
      And the output should contain:
        """
        3	1	gene
        			locus_tag	gene1
        3	1	tmRNA
        			product	tmRNA

        """


  @disable-bundler
  Scenario: Creating a ncRNA entry from using the 'feature_type' field
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
        contig1	.	gene	1	3	.	-	1	ID=gene1;feature_type=ncRNA;product=RNA signal component
        """
      And I append to "Gemfile" with:
        """
        gem 'genomer-plugin-view', :path => '../../../'
        """
     When I run `genomer view table --identifier=genome --generate_encoded_features`
     Then the exit status should be 0
      And the output should contain:
        """
        3	1	gene
        			locus_tag	gene1
        3	1	ncRNA
        			product	RNA signal component

        """

