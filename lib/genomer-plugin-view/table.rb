require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    return render
  end

  def options
    opts = Hash.new
    opts[:reset]  = true if flags[:reset_locus_numbering]
    opts[:prefix] = flags[:prefix] if flags[:prefix]
    opts[:identifier] = flags[:identifier] if flags[:identifier]
    opts
  end

  def render
    delimiter = "\t"
    indent    = delimiter * 2

    out = [%W|>Feature #{options[:identifier]} annotation_table|]
    annotations(options).map{|i| i.to_genbank_feature_row}.each do |row|
      out << row.shift
      row.each{|i| out << i.unshift(indent) }
    end
    return out.map{|line| line * delimiter} * "\n" + "\n"
  end


end
