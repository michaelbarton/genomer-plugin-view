Feature: Producing a fasta view of a scaffold
  In order to produce fasta output from a scaffold
  A user can use the "view" command
  to generate the required fasta output

  @disable-bundler
  Scenario: Generating simple fasta
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
     When I run `genomer view fasta`
     Then the exit status should be 0
      And the output should contain:
     """
     >.
     ATGGC
     """

  @disable-bundler
  Scenario: Generating simple fasta with a sequence identifier
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
     When I run `genomer view fasta --identifier=scaffold`
     Then the exit status should be 0
      And the output should contain:
     """
     >scaffold
     ATGGC
     """

  @disable-bundler
  Scenario: Generating fasta with a organism name modifier
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
     When I run `genomer view fasta --organism='genus species'`
     Then the exit status should be 0
      And the output should contain:
     """
     >. [organism=genus species]
     ATGGC
     """

  @disable-bundler
  Scenario: Generating fasta with a strain modifier
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
     When I run `genomer view fasta --strain=strain_name`
     Then the exit status should be 0
      And the output should contain:
     """
     >. [strain=strain_name]
     ATGGC
     """

  @disable-bundler
  Scenario: Generating fasta with identifier and strain modifier
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
     When I run `genomer view fasta --strain=strain_name --identifier=name`
     Then the exit status should be 0
      And the output should contain:
     """
     >name [strain=strain_name]
     ATGGC
     """
