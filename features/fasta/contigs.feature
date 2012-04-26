Feature: Producing a fasta view of scaffold contigs
  In order to produce fasta output of the scaffold contigs
  A user can use the "view" command with the "--contigs" flag
  to generate the contigs in fasta format

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
     When I run `genomer view fasta  --contigs`
     Then the exit status should be 0
      And the output should contain:
     """
     >contig00001
     ATGGC
     """

  @disable-bundler
  Scenario: A two contig scaffold generating a single sequence
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
     When I run `genomer view fasta --contigs`
     Then the exit status should be 0
      And the output should contain:
     """
     >contig00001
     ATGGCATGGC
     """

  @disable-bundler
  Scenario: A single contig scaffold containing a sequence of Ns
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
      ATGGCNNNNATGGC
      """
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-view', :path => '../../../'
      """
     When I run `genomer view fasta --contigs`
     Then the exit status should be 0
      And the output should contain:
     """
     >contig00001
     ATGGC
     >contig00002
     ATGGC
     """

  @disable-bundler
  Scenario: A two contig scaffold with an unresolved region
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "A"
      -
        unresolved:
          length: 10
      -
        sequence:
          source: "B"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >A
      AAAAA
      >B
      CCCCC
      """
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-view', :path => '../../../'
      """
     When I run `genomer view fasta --contigs`
     Then the exit status should be 0
      And the output should contain:
     """
     >contig00001
     AAAAA
     >contig00002
     CCCCC
     """

  @disable-bundler
  Scenario: A two contig scaffold with an unresolved region and gapped contig
    Given I successfully run `genomer init project`
      And I cd to "project"
      And I write to "assembly/scaffold.yml" with:
      """
      ---
      -
        sequence:
          source: "A"
      -
        unresolved:
          length: 10
      -
        sequence:
          source: "B"
      """
      And I write to "assembly/sequence.fna" with:
      """
      >A
      AAAAA
      >B
      CCCNNNNTTT
      """
      And I append to "Gemfile" with:
      """
      gem 'genomer-plugin-view', :path => '../../../'
      """
     When I run `genomer view fasta --contigs`
     Then the exit status should be 0
      And the output should contain:
     """
     >contig00001
     AAAAA
     >contig00002
     CCC
     >contig00003
     TTT
     """
