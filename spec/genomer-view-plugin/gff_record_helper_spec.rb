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
        @attn.feature('gene').attributes([['ID', 'id']])
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

    context "miscRNA feature on the positive strand" do

      let(:annotation) do
        @attn.feature('miscRNA')
      end

      it "should return a CDS table entry" do
        subject.should == <<-EOS.unindent
        1\t3\tmiscRNA
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

    context "for an unknown feature type" do

      let(:annotation) do
        @attn.feature('unknown')
      end

      it "should raise an error" do
        lambda{ subject.call }.should raise_error(Genomer::Error,"Unknown feature type 'unknown'")
      end

    end

    context "for a feature with no attributes" do

      let(:annotation) do
        @attn
      end

      it "should return an empty array" do
        subject.should be_empty
      end

    end

    context "for a feature with an unknown attribute" do

      let(:annotation) do
        @attn.attributes([['something','else']])
      end

      it "should return an empty array" do
        subject.should be_empty
      end

    end

    feature_keys = {
      :gene => [
       ['Name',    'gene'],
       ['ID',      'locus_tag']],
      :tRNA => [
       ['product', 'product'],
       ['Note',    'note']],
      :rRNA => [
       ['product', 'product'],
       ['Note',    'note']],
      :miscRNA => [
       ['product',   'product'],
       ['Note',      'note']],
      :tmRNA => [
       ['product',   'product'],
       ['Note',      'note']],
      :CDS => [
       ['ec_number', 'EC_number'],
       ['db_xref',   'db_xref'],
       ['function',  'function'],
       ['product',   'product'],
       ['Note',      'note'],
       ['ID',        'protein_id' ]]}

    feature_keys.each do |type,mappings|
      mappings.each do |a,b|
        context "#{type.to_s} feature" do

          let(:annotation) do
            @attn.feature(type.to_s).attributes([[a, :value]])
          end

          it "should return #{b} for the attribute #{a}" do
            subject.first.should_not be_nil
            subject.first.first.should == b
          end

        end
      end
    end

  end

end
