$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'heredoc_unindent'
require 'scaffolder/test/helpers'
require 'genomer-plugin-view'
require 'genomer-plugin-view/gff_record_helper'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr

  include Scaffolder::Test
  Scaffolder::Test::Annotation.send(:include, GenomerPluginView::GffRecordHelper)

  def gene(opts = Hash.new)
    default = {
      :seqname    => 'seq1',
      :start      => 1,
      :end        => 3,
      :feature    => 'gene',
      :attributes => Hash.new}
    Annotation.new(default.merge(opts)).to_gff3_record
  end

  def cds(opts = Hash.new)
    gene({:feature => 'CDS'}.merge(opts))
  end
end
