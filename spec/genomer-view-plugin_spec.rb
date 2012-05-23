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

end
