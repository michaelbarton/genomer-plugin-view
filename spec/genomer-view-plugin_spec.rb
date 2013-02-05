require 'spec_helper'

describe GenomerPluginView do

  describe "#fetch_view" do

    it "should return the required view plugin class" do
      GenomerPluginView.fetch_view('fasta').should == GenomerPluginView::Fasta
    end

  end

  describe "#run" do

    let(:example) do
      GenomerPluginView::Example = Class.new(GenomerPluginView)
    end

    context "with a view argument passed" do

      before do
        mock(described_class).fetch_view('example') do
          example
        end
      end

      it "should initialize and run the required view plugin" do
        mock.proxy(example).new([:arg],:flags) do |instance|
          mock(instance).run
        end

        described_class.new(['example',:arg],:flags).run
      end

    end

    context "with no argument passed" do

      it "should return help information" do
        described_class.new([],[]).run.should ==<<-STRING.unindent
      Run `genomer man view COMMAND` to review available formats
      Where COMMAND is one of the following:
        agp
        fasta
        gff
        mapping
        table
        STRING
      end

    end

  end

  describe '#convert_command_line_flags' do

    subject do
      described_class.convert_command_line_flags(flags)
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

end
