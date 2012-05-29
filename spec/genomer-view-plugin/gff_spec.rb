require 'spec_helper'
require 'genomer-plugin-view/gff'

describe GenomerPluginView::Gff do

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

      it "should return the header line" do
        subject.run.should == "##gff-version 3\n"
      end

    end

    describe "with one gene annotation" do

      let(:annotations){ [gene] }

      it "should return a single gene gff entry " do
        subject.run.should == <<-EOS.unindent
        ##gff-version 3
        .\t.\tgene\t1\t3\t.\t+\t1\t.
        EOS
      end

    end

    describe "with two gene annotations" do

      let(:annotations) do
        [
          gene,
          gene(:start => 4, :end => 6)
        ]
      end

      it "should return a single gene gff entry " do
        subject.run.should == <<-EOS.unindent
        ##gff-version 3
        .\t.\tgene\t1\t3\t.\t+\t1\t.
        .\t.\tgene\t4\t6\t.\t+\t1\t.
        EOS
      end

    end

    describe "with the identifier flag" do

      let(:flags){ {:identifier => 'genome'} }

      let(:annotations){ [gene] }

      it "should return a single gene gff entry " do
        subject.run.should == <<-EOS.unindent
        ##gff-version 3
        genome\t.\tgene\t1\t3\t.\t+\t1\t.
        EOS
      end

    end

  end

end
