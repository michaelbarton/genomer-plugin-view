require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GenomerPluginView do

  describe "#run" do

    describe "with fasta command" do

      before do
        mock(subject).scaffold do
          [Sequence.new(:sequence => 'AAATGA')]
        end
      end

      subject do
        described_class.new(['fasta'],flags)
      end

      describe "and no flags" do

        let(:flags){ {} }

        it "should return fasta output" do
          subject.run.should == ">. \nAAATGA\n"
        end

      end

      describe "and the --identifier flag" do

        let(:flags){ {:identifier => 'name'} }

        it "should return fasta output" do
          subject.run.should == ">name\nAAATGA\n"
        end

      end

    end

  end

end
