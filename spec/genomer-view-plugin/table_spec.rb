require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

  def gene(opts = Hash.new)
    default = {
      :seqname    => 'seq1',
      :start      => 1,
      :end        => 3,
      :feature    => 'gene',
      :attributes => Hash.new}
    Annotation.new(default.merge(opts)).to_gff3_record
  end

  def cds(opts = Hash.new)
    gene({:feature => 'CDS'}.merge(opts))
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

    describe "with one gene annotation" do

      let(:annotations){ [gene] }

      it "should call the to_genbank_features method " do
        subject.run.should == <<-EOS.unindent
        >Feature\t\tannotation_table
        1\t3\tgene
        EOS
      end

    end

    describe "with one gene annotation and the CDS flag" do

      let(:flags){ {:generate_encoded_features => true} }

      let(:annotations){ [gene] }

      it "should call the to_genbank_features method " do
        subject.run.should == <<-EOS.unindent
        >Feature\t\tannotation_table
        1\t3\tgene
        1\t3\tCDS
        EOS
      end

    end

    describe "with one gene annotation and the CDS prefix flag" do

      let(:flags){ {:generate_encoded_features => 'pre_'} }

      let(:annotations){ [gene({:attributes => {'ID' => '1'}})] }

      it "should call the to_genbank_features method " do
        subject.run.should == <<-EOS.unindent
        >Feature\t\tannotation_table
        1\t3\tgene
        \t\t\tlocus_tag\t1
        1\t3\tCDS
        \t\t\tprotein_id\tpre_1
        EOS
      end

    end

    describe "with one tRNA gene annotation and the CDS prefix flag" do

      let(:flags){ {:generate_encoded_features => 'pre_'} }

      let(:annotations){ [gene({:attributes => {'ID'           => '1',
                                                'feature_type' => 'tRNA',
                                                'product'      => 'tRNA-Gly'}})] }

      it "should call the to_genbank_features method " do
        subject.run.should == <<-EOS.unindent
        >Feature\t\tannotation_table
        1\t3\tgene
        \t\t\tlocus_tag\t1
        1\t3\ttRNA
        \t\t\tproduct\ttRNA-Gly
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

    describe "with the generate_encoded_features command line argument" do

      let(:flags) do
        {:'generate_encoded_features' => true}
      end

      it "should return the prefix argument" do
        subject.should == {:encoded => true}
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

  describe "#create_encoded_features" do

    def annotations(attns,prefix = true)
      described_class.new([],{}).create_encoded_features(attns,prefix)
    end

    it "should return an empty array when passed an empty array" do
      annotations([]).should be_empty
    end

    it "should duplicate a simple gene entry" do
      annotations([gene]).last.to_s.should == cds.to_s
    end

    it "should create a different entry type when specified" do
      g = gene(:attributes => {'ID' => '1',     'feature_type' => 'tRNA', 'product' => 'tRNA-Gly'})
      c = gene(:attributes => {'ID' => 'pre_1', 'feature_type' => 'tRNA', 'product' => 'tRNA-Gly'})
      c.feature = "tRNA"

      a = annotations([g],'pre_').last.to_s.should == c.to_s
    end

    it "should prefix the ID in the protein_id attribute" do
      g = gene(:attributes => {'ID' => '1'})
      c = cds(:attributes  => {'ID' => 'pre_1'})
      a = annotations([g],'pre_').last.to_s.should == c.to_s
    end

    it "should uppercase the Name attribute for the CDS" do
      g = gene(:attributes => {'Name' => 'abcD'})
      c = cds(:attributes  => {'Name' => 'AbcD'})
      annotations([g],'pre_').last.to_s.should == c.to_s
    end

    it "should preserve the Name attribute for the gene " do
      g = gene(:attributes => {'Name' => 'abcD'})
      c = cds(:attributes  => {'Name' => 'AbcD'})
      annotations([g],'pre_').first.attributes.should == [['Name', 'abcD']]
    end

    it "should add the product attribute" do
      g = gene(:attributes => {'product' => 'abcD'})
      c = cds(:attributes  => {'Name'    => 'AbcD'})
      a = annotations([g],'pre_').last.to_s.should == c.to_s
    end

    it "should overide the Name attribute with the product attribute" do
      g = gene(:attributes => {'Name' => 'xyz', 'product' => 'abcd'})
      c = cds(:attributes  => {'Name' => 'Abcd'})
      a = annotations([g],'pre_').last.to_s.should == c.to_s
    end

  end

end
