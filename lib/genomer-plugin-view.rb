require 'genomer'

class GenomerPluginView < Genomer::Plugin

  def run
    self.class.fetch_view(arguments.shift).new(arguments,flags).run
  end

  def self.fetch_view(view)
    require 'genomer-plugin-view/' + view
    const_get(view.capitalize)
  end

  def self.convert_command_line_flags(flags)
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

end
