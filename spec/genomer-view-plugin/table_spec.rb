require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

  subject do
    described_class.new([],flags)
  end

  before do
    stub(subject).annotations do
      annotations
    end
  end

  describe "with no annotations" do

    let(:flags){ {:identifier => 'name'} }

    let(:annotations){ [] }

    it "should return the header line" do
      subject.run.should == ">Feature\tname\tannotation_table\n"
    end

  end

  describe "with one annotation" do

    let(:flags){ {:identifier => 'name'} }

    let(:annotations) do
      [Annotation.new(
        :seqname    => 'seq1',
        :start      => 1,
        :end        => 3,
        :feature    => 'gene',
        :attributes => {})]
    end

    it "should return the header line and annotation" do
      subject.run.should == <<-EOS.unindent
      >Feature\tname\tannotation_table
      1\t3\tgene
      EOS
    end

  end

end
