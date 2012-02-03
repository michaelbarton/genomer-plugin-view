require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

  describe "#render" do

    subject do
      described_class.new([],{})
    end

    before do
      stub(subject).annotations do
        annotations
      end
      stub(subject).options do
        options
      end
    end

    let(:options){ {} }

    let(:gff_entry) do
      Annotation.new(
        :seqname    => 'seq1',
        :start      => 1,
        :end        => 3,
        :feature    => 'gene',
        :attributes => {'ID' => 'gene1'})
    end

    describe "with no annotations" do

      let(:annotations){ [] }

      it "should return just the header line" do
        subject.render.should == ">Feature\t\tannotation_table\n"
      end

    end

    describe "with the identifier command line argument" do

      let(:options) do
        {:identifier => 'name'}
      end

      let(:annotations) do
        [gff_entry]
      end

      it "should return the header line and annotation" do
        subject.render.should == <<-EOS.unindent
        >Feature\tname\tannotation_table
        1\t3\tgene
        \t\t\tlocus_tag\tgene1
        EOS
      end

    end

    describe "with the 'Name' gff attribute" do

      let(:annotations) do
        e = gff_entry.clone
        e.attributes.merge!({'Name' => 'name'})
        [e]
      end

      it "should return the header line and annotation" do
        subject.render.should == <<-EOS.unindent
        >Feature\t\tannotation_table
        1\t3\tgene
        \t\t\tlocus_tag\tgene1
        \t\t\tgene\tname
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

    describe "with an unknown command line arguments" do

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

    describe "with the identifer command line argument" do

      let(:flags) do
        {:identifier => 'something'}
      end

      it "should return the prefix argument" do
        subject.should == {:identifier => 'something'}
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
