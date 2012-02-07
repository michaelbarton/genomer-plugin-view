require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    header = ">Feature\t#{options[:identifier]}\tannotation_table\n"

    attns = annotations(options)
    attns = create_cds_entries(attns, options[:cds]) if options[:cds]

    attns.inject(header) do |table,attn|
      table << attn.to_genbank_table_entry
    end
  end

  def options
    flags.inject(Hash.new) do |hash,(k,v)|
      k = case k
      when :identifier            then k
      when :prefix                then k
      when :create_cds            then :cds
      when :reset_locus_numbering then :reset
      else nil
      end

      hash[k] = v if k
      hash
    end
  end

  def create_cds_entries(genes,prefix)
    cdss = genes.map do |gene|
      cds = gene.clone
      cds.feature = "CDS"
      cds.attributes = cds.attributes.map do |(k,v)|
        v = case k
        when 'protein_id' then (prefix.is_a?(String) ? prefix + v : v)
        else v
        end
        [k,v]
      end
      cds
    end
    genes.zip(cdss).flatten
  end

end
