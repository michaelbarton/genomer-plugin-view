require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GenomerPluginView do

  describe "#run" do

    describe "with fasta option given" do

      describe "passed a scaffold with a single sequence" do

        let(:scaffold) do
          [ Sequence.new(:sequence => 'AAATGA') ]
        end

        subject do
          described_class.new(scaffold,{:format => :fasta,:identifier => 'scaf1'})
        end

        it "should return fasta output" do
          subject.run.should == ">scaf1\nAAATGA\n"
        end

      end

    end

  end

end
