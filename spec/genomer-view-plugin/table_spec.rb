require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

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

  describe "#create_encoded_features" do

    let(:prefix) do
      nil
    end

    subject do
      described_class.new([],{}).create_encoded_features(annotations,prefix).last
    end

    describe "passed an empty array" do

      let(:annotations) do
        []
      end

      it "should return an empty array" do
        subject.should be_nil
      end

    end

    describe "passed a gene with no attributes" do

      let(:annotations) do
        [gene]
      end

      it "should return a CDS feature" do
        subject.should == cds
      end

    end

    describe "passed a gene with a known feature_type attribute" do

      let(:attributes) do
        {'feature_type' => 'tRNA'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should return a tRNA feature" do
        subject.should == gene({:feature => 'tRNA',:attributes => attributes})
      end

    end

    describe "passed a gene with an unknown feature_type attribute" do

      let(:attributes) do
        {'feature_type' => 'unknown'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should raise a Genomer::Error" do
        lambda{ subject.call }.should raise_error Genomer::Error,
          "Unknown feature_type 'unknown'"
      end

    end

    describe "passed a gene with a Name attribute" do

      let(:attributes) do
        {'Name' => 'abcD'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should set the capitalise value to the product key" do
        subject.should have_identical_attributes cds({:attributes => {'product' => 'AbcD'}})
      end

    end

    describe "passed a gene with a product attribute" do

      let(:attributes) do
        {'product' => 'abcd'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should not change attributes" do
        subject.should have_identical_attributes cds({:attributes => attributes})
      end

    end

    describe "passed a gene with a function attribute" do

      let(:attributes) do
        {'function' => 'abcd'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should not change attributes" do
        subject.should have_identical_attributes cds({:attributes => attributes})
      end

    end

    describe "passed a gene with product and function attributes" do

      let(:attributes) do
        {'product' => 'abcd', 'function' => 'efgh'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should not change attributes" do
        subject.should have_identical_attributes cds({:attributes => attributes})
      end

    end

    describe "passed a gene with Name and product attributes" do

      let(:attributes) do
        {'Name' => 'abcD','product' => 'efgh'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should map Name to product and product to function" do
        subject.should have_identical_attributes cds({:attributes =>
          {'product' => 'AbcD','function' => 'efgh'}})
      end

    end

    describe "passed a gene with Name, product and function attributes" do

      let(:attributes) do
        {'Name' => 'abcD','product' => 'efgh', 'function' => 'ijkl'}
      end

      let(:annotations) do
        [gene({:attributes => attributes})]
      end

      it "should map Name to product and product to function" do
        subject.should have_identical_attributes cds({:attributes =>
          {'product' => 'AbcD','function' => 'efgh'}})
      end

    end

  end

end
