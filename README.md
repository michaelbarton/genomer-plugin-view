![View: the blossom of a genome assembly](http://genomer.s3.amazonaws.com/icon/view/view.jpg)

## About

View is a plugin for the [genomer][] tool for genome projects. This plugin can
be used to generate the files required to upload a genome project. The files
generated includes sequence and annotation files. Each of the possible file
formats is documented with a [manual page][man].

[genomer]: https://github.com/michaelbarton/genomer
[man]: https://github.com/michaelbarton/genomer-plugin-view/tree/master/man

## Usage

The following examples are taken from the [Pseudomonas fluorescens R124][r124]
genome project. These examples can be run by downloading this project and
running bundle install.

[r124]: https://github.com/michaelbarton/chromosome-pfluorescens-r124-genome

The following command can be used to generate a fasta file with associated
metadata:

    genomer view fasta                                 \
      --identifier='PRJNA68653'                        \
      --organism='Pseudomonas fluorescens'             \
      --strain='R124'                                  \
      --gcode='11'                                     \
      --topology='circular'                            \
      --isolation-source='Orthoquartzite Cave Surface' \
      --collection-date='17-Oct-2007'                  \
      --completeness='Complete'                        \

    >PRJNA68653 [organism=Pseudomonas fluorescens] [strain=R124] [gcode=11] ...
    TGTTACCTGGTTCGTCCACAACGGGCCGGAATGGCCCCCGTTTTAAGAGACCGGGGATTCTAGAGAAAGC
    AAGCCTTCAGGTCAATTTCCAACCAACGTTTCCTTATAAATAGATATCTGGAGCATCCAGAACCAAGACC
    TTGCCTGCCAAACATAAAAATAAAGAAGGGAATTATTTAAAGCTTTTCTGTAAAGCTTATAAAAGCTAGG
    GCGACAGTCTCTGTGGATAACCATGTTCAGCCCTTGTCTGGCTTGATGTACAGAGAATGACAACTACAGT
    GGAAAACCGTGGTCAGCCTGTGCTGCGCTGTCGGATAACCTGTGTGTGGAACCGTCAGTTATCCACAGGC
    AGGTTATCCACCGAGTTCCACCCCCAGTTGTCCAGTGCCCTCAGAGGCGGTTATCCACAGAGCTTATTCA
    CACACCGTTGGTCGCCTTTTTACCGGTTAACGCATTGATTAATCATGGTCACCACACAACCTGCATGTGG
    ...

The following can be used to generate an annotation table suitable for
submission to GenBank using tbl2asn.

    genomer view table					                      \
      --identifier=PRJNA68653                         \
      --reset_locus_numbering=52                      \
      --prefix='I1A_'                                 \
      --generate_encoded_features='gnl|BartonUAkron|' \

    >Feature	PRJNA68653	annotation_table
    562	2076	gene
          locus_tag	I1A_000052
          gene	dnaA
    562	2076	CDS
          protein_id	gnl|BartonUAkron|I1A_000052
          product	DnaA
          function	chromosomal replication initiator protein
    2116	3219	gene
          locus_tag	I1A_000053
    2116	3219	CDS
          protein_id	gnl|BartonUAkron|I1A_000053
          product	DNA polymerase III, beta subunit
    ...

## Installation

Add this line to your genomer projects's Gemfile:

    gem 'genomer-plugin-view'

And then execute in the project directory:

    $ bundle

Run the `help` command and the summary plugin should be available:

    $ genomer help
    $ genomer man view

## Copyright

Genomer copyright (c) 2010 by Michael Barton. Genomer is licensed under the MIT
license. See LICENSE.txt for further details. The Star of Bethlehem image is
used under a Creative Commons Generic 2.0 Licence. The original can be [found
on flickr.][flickr]

[flickr]: http://www.flickr.com/photos/mamjodh/4547707941/
