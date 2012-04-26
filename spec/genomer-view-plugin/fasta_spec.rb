require 'spec_helper'
require 'genomer-plugin-view/fasta'

describe GenomerPluginView::Fasta do

  before do
    mock(subject).scaffold do
      annotations
    end
  end

  let (:annotations) do
    [Sequence.new(:sequence => 'AAATGA')]
  end

  subject do
    described_class.new(['fasta'],flags)
  end

  describe "with no options" do

    let(:flags){ {} }

    it "should return fasta output" do
      subject.run.should == ">.\nAAATGA\n"
    end

  end

  describe "run with the --identifier option" do

    let(:flags){ {:identifier => 'name'} }

    it "should return fasta output with the identifier" do
      subject.run.should == ">name\nAAATGA\n"
    end

  end

  describe "run with the --organism option" do

    let(:flags){ {:organism => 'name'} }

    it "should return fasta output with the organism modifier" do
      subject.run.should == ">. [organism=name]\nAAATGA\n"
    end

  end

  describe "run with the --strain option" do

    let(:flags){ {:strain => 'name'} }

    it "should return fasta output with the strain modifier" do
      subject.run.should == ">. [strain=name]\nAAATGA\n"
    end

  end

  describe "run with the identifier and a modifier option" do

    let(:flags){ {:strain => 'isolate', :identifier => 'name'} }

    it "should return fasta output with the strain modifier" do
      subject.run.should == ">name [strain=isolate]\nAAATGA\n"
    end

  end

  describe "run with the --contigs option" do

    let(:flags){ {:contigs => true} }

    context "with an ungapped contig scaffold" do

      it "should return fasta output of the contig" do
        subject.run.should == ">contig00001\nAAATGA\n"
      end

    end

    context "with a gapped contig scaffold" do

      let(:annotations) do
        [Sequence.new(:sequence => 'AAANNNNTTT')]
      end

      it "should return fasta output of the contig" do
        subject.run.should == ">contig00001\nAAA\n>contig00002\nTTT\n"
      end

    end

  end

end
