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

      attrs = Hash[cds.attributes]

      if id = attrs['ID']
        attrs['ID'] = (prefix.is_a?(String) ? prefix + id : id)
      end

      if type = attrs['entry_type']
        cds.feature = type
      else
        cds.feature = "CDS"

        if product = attrs['product']
          attrs['Name'] = product
          attrs.delete('product')
        end

        if name = attrs['Name']
          name = name.clone
          name[0] = name[0].upcase
          attrs['Name'] = name
        end

      end




      cds.attributes = attrs.to_a
      cds
    end
    genes.zip(cdss).flatten
  end

end
