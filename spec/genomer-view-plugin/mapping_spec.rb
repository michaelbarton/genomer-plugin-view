require 'spec_helper'
require 'genomer-plugin-view/mapping'

describe GenomerPluginView::Mapping do

  describe "#run" do

    let(:annotations){ [] }

    let(:flags){ {} }

    before(:each) do
      stub(subject).annotations do
        annotations
      end
      stub(subject).flags do
        {}
      end
    end

    subject do
      described_class.new([],{})
    end

    describe "with no annotations or flags" do

      it "should return an empty mapping" do
        subject.run.should == ""
      end

    end

  end

end
