require 'spec_helper'
require 'genomer-plugin-view/gff_record_helper'

describe GenomerPluginView::GffRecordHelper do

  describe "module" do
    it "should be included in Bio::GFF::GFF3::Record" do
      Bio::GFF::GFF3::Record.ancestors.should include(described_class)
    end
  end

  describe "#negative_strand?" do

    subject do
      Annotation.new
    end

    it "should return false for a positive strand annotation" do
      subject.strand('+').to_gff3_record.
        negative_strand?.should be_false
    end

    it "should return true for a negative strand annotation" do
      subject.strand('-').to_gff3_record.
        negative_strand?.should be_true
    end

  end

  describe "#to_genbank_table_entry" do

    before(:each) do
      @attn = Annotation.new(:start => 1, :end => 3, :strand => '+',:feature => 'gene')
    end

    subject do
      annotation.to_gff3_record.to_genbank_table_entry
    end

    context "gene feature on the positive strand" do

      let(:annotation) do
        @attn
      end

      it "should return a table entry" do
        subject.should == <<-EOS.unindent
        1\t3\tgene
        EOS
      end

    end

    context "gene feature on the negative strand" do

      let(:annotation) do
        @attn.strand('-')
      end

      it "should return a table entry" do
        subject.should == <<-EOS.unindent
        3\t1\tgene
        EOS
      end

    end

    context "gene feature with attributes" do

      let(:annotation) do
        @attn.feature('gene').attributes('ID' => 'id')
      end

      it "should return a table entry" do
        subject.should == <<-EOS.unindent
        1\t3\tgene
        \t\t\tlocus_tag\tid
        EOS
      end

    end

    context "CDS feature on the positive strand" do

      let(:annotation) do
        @attn.feature('CDS')
      end

      it "should return a CDS table entry" do
        subject.should == <<-EOS.unindent
        1\t3\tCDS
        EOS
      end

    end

    context "tRNA feature on the positive strand" do

      let(:annotation) do
        @attn.feature('tRNA')
      end

      it "should return a CDS table entry" do
        subject.should == <<-EOS.unindent
        1\t3\ttRNA
        EOS
      end

    end

    context "tmRNA feature on the positive strand" do

      let(:annotation) do
        @attn.feature('tmRNA')
      end

      it "should return a CDS table entry" do
        subject.should == <<-EOS.unindent
        1\t3\ttmRNA
        EOS
      end

    end

    context "rRNA feature on the positive strand" do

      let(:annotation) do
        @attn.feature('rRNA')
      end

      it "should return a CDS table entry" do
        subject.should == <<-EOS.unindent
        1\t3\trRNA
        EOS
      end

    end

    context "ncRNA feature on the positive strand" do

      let(:annotation) do
        @attn.feature('ncRNA')
      end

      it "should return a CDS table entry" do
        subject.should == <<-EOS.unindent
        1\t3\tncRNA
        EOS
      end

    end

  end

  describe "#table_attributes" do

    before(:each) do
      @attn = Annotation.new(:start => 1, :end => 3, :strand => '+', :feature => 'gene')
    end

    subject do
      annotation.to_gff3_record.table_attributes
    end

    context "gene feature with no attributes" do

      let(:annotation) do
        @attn
      end

      it "should return an empty array" do
        subject.should be_empty
      end

    end

    context "gene feature with an unknown attribute" do

      let(:annotation) do
        @attn.feature('gene').attributes('something' => 'else')
      end

      it "should return an empty array" do
        subject.should be_empty
      end

    end

    context "gene feature with an ID attribute" do

      let(:annotation) do
        @attn.attributes('ID' => 'two')
      end

      it "should map to the locus_tag" do
        subject.should == [['locus_tag','two']]
      end

    end

    context "gene feature with a Name attribute" do

      let(:annotation) do
        @attn.attributes('Name' => 'something')
      end

      it "should map to the gene tag" do
        subject.should == [['gene','something']]
      end

    end

    context "CDS feature with a ID attribute" do

      let(:annotation) do
        @attn.feature('CDS').attributes('ID' => 'something')
      end

      it "should map to the protein_id tag" do
        subject.should == [['protein_id','something']]
      end

    end

    context "CDS feature with a Name attribute" do

      let(:annotation) do
        @attn.feature('CDS').attributes('Name' => 'something')
      end

      it "should map to the protein_id tag" do
        subject.should == [['product','something']]
      end

    end

    context "CDS feature with a Note attribute" do

      let(:annotation) do
        @attn.feature('CDS').attributes('Note' => 'something')
      end

      it "should map to the protein_id tag" do
        subject.should == [['note','something']]
      end

    end

    context "CDS feature with a ec_number attribute" do

      let(:annotation) do
        @attn.feature('CDS').attributes('ec_number' => 'something')
      end

      it "should map to the EC_number tag" do
        subject.should == [['EC_number','something']]
      end

    end

    context "CDS feature with a function attribute" do

      let(:annotation) do
        @attn.feature('CDS').attributes('function' => 'something')
      end

      it "should map to the function tag" do
        subject.should == [['function','something']]
      end

    end

    context "tRNA feature with product and Note attributes" do

      let(:annotation) do
        @attn.feature('tRNA').attributes('product' => 'something','Note' => 'else')
      end

      it "should map to the product tag" do
        subject.should == [['product','something'],['note','else']]
      end

    end

    context "tRNA feature with feature_type attribute" do

      let(:annotation) do
        @attn.feature('tRNA').attributes('feature_type' => 'something')
      end

      it "should not map to anything" do
        subject.should == []
      end

    end

    context "An unknown feature type" do

      let(:annotation) do
        @attn.feature('unknown')
      end

      it "should raise an error" do
        lambda{ subject.call }.should raise_error(Genomer::Error,"Unknown feature type 'unknown'")
      end

    end

  end

end
