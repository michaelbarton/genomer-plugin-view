require 'spec_helper'
require 'genomer-plugin-view/agp'

describe GenomerPluginView::Agp do

  def contig(sequence)
    s = mock!
    stub(s).entry_type{ :sequence }
    stub(s).sequence{ sequence }
    s
  end

  def unresolved(length)
    s = mock!
    stub(s).entry_type{ :unresolved }
    stub(s).sequence{ 'N' * length }
    s
  end

  subject do
    described_class.new(['agp'],{})
  end

  before do
    mock(subject).scaffold do
      contigs
    end
  end

  context "where the scaffold contains a single contig" do

    let (:contigs) do
      [contig('AATGC')]
    end

    it "should return agp output" do
      subject.run.should == <<-EOS.unindent
        ##agp-version	2.0
        scaffold	1	5	1	W	contig00001	1	5	+
      EOS
    end

  end

  context "where the scaffold contains a contig with a gap" do

    let (:contigs) do
      [contig('AAANNNGGG')]
    end

    it "should return agp output" do
      subject.run.should == <<-EOS.unindent
        ##agp-version	2.0
        scaffold	1	3	1	W	contig00001	1	3	+
        scaffold	4	6	2	N	3	contig	yes	<required>
        scaffold	7	9	3	W	contig00002	1	3	+
      EOS
    end

  end

  context "where the scaffold contains an unresolved region" do

    let (:contigs) do
      [ contig('AAA'), unresolved(3), contig('TTT') ]
    end

    it "should return agp output" do
      subject.run.should == <<-EOS.unindent
        ##agp-version	2.0
        scaffold	1	3	1	W	contig00001	1	3	+
        scaffold	4	6	2	N	3	scaffold	yes	<required>
        scaffold	7	9	3	W	contig00002	1	3	+
      EOS
    end

  end

end
