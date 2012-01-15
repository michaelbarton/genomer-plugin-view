require 'spec_helper'
require 'genomer-plugin-view/fasta'

describe GenomerPluginView::Fasta do

  before do
    mock(subject).scaffold do
      [Sequence.new(:sequence => 'AAATGA')]
    end
  end

  subject do
    described_class.new(['fasta'],flags)
  end

  describe "with no options" do

    let(:flags){ {} }

    it "should return fasta output" do
      subject.run.should == ">. \nAAATGA\n"
    end

  end

  describe "run with the --identifier option" do

    let(:flags){ {:identifier => 'name'} }

    it "should return fasta output with the identifier" do
      subject.run.should == ">name\nAAATGA\n"
    end

  end

end
