require 'spec_helper'
require 'genomer-plugin-view/mapping'

describe GenomerPluginView::Mapping do

  describe "#run" do

    let(:annotations) do
      [
        gene(:start => 1,  :end => 3,  :attributes => {'ID' => 'gene1'}),
        gene(:start => 4,  :end => 6,  :attributes => {'ID' => 'gene2'}),
        gene(:start => 7,  :end => 9,  :attributes => {'ID' => 'gene3'}),
        gene(:start => 10, :end => 12, :attributes => {'ID' => 'gene4'})
      ]
    end

    before(:each) do
      stub(Scaffolder::AnnotationLocator).new do
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

      let(:flags){ {} }

      let(:annotations){ [] }

      it "should return an empty mapping" do
        subject.run.should == ""
      end

    end

    describe "with some annotations" do

      let(:flags){ {} }

      it "should return a mapping of the same ids" do
        subject.run.should == <<-EOS.unindent.strip
        gene1\tgene1
        gene2\tgene2
        gene3\tgene3
        gene4\tgene4
        EOS
      end

    end

    describe "with the prefix flag" do

      let(:flags){ {:prefix => 'pre_'} }

      it "should return a mapping to the prefixed ids" do
        subject.run.should == <<-EOS.unindent.strip
        gene1\tpre_gene1
        gene2\tpre_gene2
        gene3\tpre_gene3
        gene4\tpre_gene4
        EOS
      end

    end

    describe "with the reset_locus_numbering flag " do

      let(:flags){ {:reset_locus_numbering => true} }

      it "should return a mapping to the reset ids" do
        subject.run.should == <<-EOS.unindent.strip
        gene1\t000001
        gene2\t000002
        gene3\t000003
        gene4\t000004
        EOS
      end

    end

  end

end
