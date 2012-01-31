require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    return render
  end

  def options
    opts = Hash.new
    opts[:reset] = true if flags[:reset_locus_numbering]
    opts
  end

  def render
    delimiter = "\t"
    indent    = delimiter * 2

    out = [%W|>Feature #{flags[:identifier]} annotation_table|]
    puts flags
    annotations(options).map{|i| i.to_genbank_feature_row}.each do |row|
      out << row.shift
      row.each{|i| out << i.unshift(indent) }
    end
    return out.map{|line| line * delimiter} * "\n" + "\n"
  end


end
