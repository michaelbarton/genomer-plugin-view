require 'genomer'
require 'genomer-plugin-view/gff_record_helper'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    options = GenomerPluginView.convert_command_line_flags(flags)

    header = ">Feature\t#{options[:identifier]}\tannotation_table\n"

    attns = annotations(options)
    attns = create_encoded_features(attns, options[:encoded]) if options[:encoded]

    attns.inject(header) do |table,attn|
      table << attn.to_genbank_table_entry
    end
  end

  SUPPORTED_FEATURE_TYPES = ['CDS','rRNA','tRNA','miscRNA','tmRNA']

  def create_encoded_features(genes,prefix)
    features = genes.map do |gene|
      feature = gene.clone
      attrs   = Hash[feature.attributes]

      if id = attrs['ID']
        attrs['ID'] = (prefix.is_a?(String) ? prefix + id : id)
      end

      feature.feature = attrs['feature_type'] || 'CDS'

      unless SUPPORTED_FEATURE_TYPES.include?(feature.feature)
        raise Genomer::Error, "Unknown feature_type '#{feature.feature}'"
      end

      if feature.feature == "CDS"
        name, prdt, ftn = attrs['Name'], attrs['product'], attrs['function']

        if name
          name = name.clone
          name[0] = name[0].upcase
          prdt, ftn = name,prdt
        end

        attrs.delete('Name')
        attrs['product']  = prdt
        attrs['function'] = ftn
      end

      feature.attributes = attrs.to_a.reject{|(_,value)| value.nil? }
      feature
    end
    genes.zip(features).flatten
  end

end
