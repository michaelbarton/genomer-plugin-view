require 'spec_helper'
require 'genomer-plugin-view/agp'

describe GenomerPluginView::Agp do

  let (:contigs) do
    [Sequence.new(:sequence => 'AATGC')]
  end

  subject do
    described_class.new(['agp'],flags)
  end

  before do
    mock(subject).scaffold do
      contigs
    end
  end

  let(:flags){ {} }

  describe "with no options" do

    context "where the scaffold contains a single contig" do

      it "should return agp output" do
        subject.run.should == <<-EOS.unindent
        ##agp-version	2.0
        scaffold	1	5	1	W	contig00001	1	5	+
        EOS
      end

    end

  end

end
