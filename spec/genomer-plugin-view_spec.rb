require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GenomerPluginView do

  describe "#run" do

    describe "with fasta option " do

      describe "and a scaffold with a single sequence" do

        before do
          mock(subject).scaffold do
            [Sequence.new(:sequence => 'AAATGA')]
          end
        end

        subject do
          described_class.new(['fasta'],{})
        end

        it "should return fasta output" do
          subject.run.should == ">. \nAAATGA\n"
        end

      end

    end

  end

end
