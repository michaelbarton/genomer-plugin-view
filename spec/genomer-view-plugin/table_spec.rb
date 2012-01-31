require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

  subject do
    described_class.new([],flags)
  end

  let(:options) do
    {}
  end

  let(:flags) do
    {:identifier => 'name'}
  end

  before do
    mock(subject).annotations(options) do
      annotations
    end
  end

  describe "with no annotations" do

    let(:annotations){ [] }

    it "should return the header line" do
      subject.run.should == ">Feature\tname\tannotation_table\n"
    end

  end

  describe "with one annotation" do

    describe "and only the identifier flag" do

      let(:annotations) do
        [Annotation.new(
          :seqname    => 'seq1',
          :start      => 1,
          :end        => 3,
          :feature    => 'gene',
          :attributes =>  {'ID' => 'gene1'})]
      end

      it "should return the header line and annotation" do
        subject.run.should == <<-EOS.unindent
        >Feature\tname\tannotation_table
        1\t3\tgene
        \t\t\tlocus_tag\tgene1
        EOS
      end

    end

    describe "and the number from origin flag" do

      let(:flags){ {:identifier => 'name', :reset_locus_numbering => true} }

      let(:options) do
        {:reset => true}
      end

      let(:annotations) do
        [Annotation.new(
          :seqname    => 'seq1',
          :start      => 1,
          :end        => 3,
          :feature    => 'gene',
          :attributes =>  {'ID' => '000001'})]
      end

      it "should return the header line and annotation" do
        subject.run.should == <<-EOS.unindent
        >Feature\tname\tannotation_table
        1\t3\tgene
        \t\t\tlocus_tag\t000001
        EOS
      end

    end

  end

end
