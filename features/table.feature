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

