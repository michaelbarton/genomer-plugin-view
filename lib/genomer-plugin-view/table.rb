require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    self.class.render annotations(options), options
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

  def self.render(annotations,options)
    table = ">Feature\t#{options[:identifier]}\tannotation_table\n"
    annotations.each do |attn|
      table << attn.to_genbank_table_entry
    end
    table
  end

end
