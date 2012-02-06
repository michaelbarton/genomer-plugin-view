require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

  def gene
    Annotation.new(
      :seqname    => 'seq1',
      :start      => 1,
      :end        => 3,
      :feature    => 'gene',
      :attributes => Hash.new)
  end

  describe "#run" do

    let(:annotations){ [] }

    let(:flags){ {} }

    before(:each) do
      stub(subject).annotations do
        annotations
      end
      stub(subject).flags do
        flags
      end
    end

    subject do
      described_class.new([],{})
    end

    describe "with no annotations or flags" do

      it "should return an empty header line" do
        subject.run.should == ">Feature\t\tannotation_table\n"
      end

    end

    describe "with no annotations and the identifier flag" do

      let(:flags){ {:identifier => 'id'} }

      it "should add ID to the header line" do
        subject.run.should == ">Feature\tid\tannotation_table\n"
      end

    end

    describe "with one annotation" do

      let(:annotations){ [gene] }

      it "should call the to_genbank_features method " do
        subject.run.should == <<-EOS.unindent
        >Feature\t\tannotation_table
        1\t3\tgene
        EOS
      end

    end

  end

  describe '#options' do

    subject do
      described_class.new([],flags).options
    end

    describe "with no command line arguments" do

      let(:flags) do
        {}
      end

      it "should return an empty hash" do
        subject.should == {}
      end

    end

    describe "with an unrelated command line argument" do

      let(:flags) do
        {:something => :unknown}
      end

      it "should return an empty hash" do
        subject.should == {}
      end

    end

    describe "with the prefix command line argument" do

      let(:flags) do
        {:prefix => 'pre_'}
      end

      it "should return the prefix argument" do
        subject.should == {:prefix => 'pre_'}
      end

    end

    describe "with the reset_locus_numbering command line argument" do

      let(:flags) do
        {:reset_locus_numbering => true}
      end

      it "should map this to the the reset argument" do
        subject.should == {:reset => true}
      end

    end

  end

end
