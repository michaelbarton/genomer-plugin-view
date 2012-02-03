require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    return render
  end

  def options
    flags.inject(Hash.new) do |hash,(k,v)|
      k = case k
      when :identifier            then k
      when :prefix                then k
      when :reset_locus_numbering then :reset
      else nil
      end

      hash[k] = v if k
      hash
    end
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
