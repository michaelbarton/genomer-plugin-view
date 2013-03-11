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
      attrs   = feature.attributes.clone

      feature_type    = attrs.detect{|k,v| k == 'feature_type'}
      feature.feature = (feature_type ? feature_type.last : 'CDS')

      unless SUPPORTED_FEATURE_TYPES.include?(feature.feature)
        raise Genomer::Error, "Unknown feature_type '#{feature.feature}'"
      end

      attrs.map! do |(k,v)|
        v = (k == 'ID' && prefix.instance_of?(String) ? prefix + v : v)
        [k,v]
      end

      if feature.feature == "CDS"

        if attrs.detect{|(k,v)| k == 'Name' }
          attrs.map! do |(k,v)|
            v      = v.clone
            v[0,1] = v[0,1].upcase if k == 'Name'

            v = nil                if k == 'function'
            k = 'function'         if k == 'product'
            k = 'product'          if k == 'Name'
            [k,v]
          end
        end
        #attrs.delete('Name')
      end

      feature.attributes = attrs.reject{|(_,value)| value.nil? }
      feature
    end
    genes.zip(features).flatten
  end

end
