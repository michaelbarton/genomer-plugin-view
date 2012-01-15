require 'spec_helper'
require 'genomer-plugin-view/table'

describe GenomerPluginView::Table do

  subject do
    described_class.new([],flags)
  end

  describe "with no annotations" do

    let(:flags){ {:identifier => 'name'} }

    it "should return the header line" do
      subject.run.should == ">Feature	name	annotation_table\n"
    end

  end

end
