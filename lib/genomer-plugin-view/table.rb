require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    header = ">Feature\t#{options[:identifier]}\tannotation_table\n"

    attns = annotations(options)
    attns = create_encoded_features(attns, options[:encoded]) if options[:encoded]

    attns.inject(header) do |table,attn|
      table << attn.to_genbank_table_entry
    end
  end

  def options
    flags.inject(Hash.new) do |hash,(k,v)|
      k = case k
      when :identifier                then k
      when :prefix                    then k
      when :generate_encoded_features then :encoded
      when :reset_locus_numbering     then :reset
      else nil
      end

      hash[k] = v if k
      hash
    end
  end

  def create_encoded_features(genes,prefix)
    features = genes.map do |gene|
      feature = gene.clone

      attrs = Hash[feature.attributes]

      if id = attrs['ID']
        attrs['ID'] = (prefix.is_a?(String) ? prefix + id : id)
      end

      if type = attrs['feature_type']
        feature.feature = type
      else
        feature.feature = "CDS"

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

      feature.attributes = attrs.to_a
      feature
    end
    genes.zip(features).flatten
  end

end
