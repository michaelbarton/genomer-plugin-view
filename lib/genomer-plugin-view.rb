require 'genomer'

class GenomerPluginView < Genomer::Plugin

  def run
    return help if arguments.empty?
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

  def help
    message = <<-STRING.unindent
      Run `genomer man view COMMAND` to review available formats
      Where COMMAND is one of the following:
    STRING

    message + Dir[File.dirname(__FILE__) + '/genomer-plugin-view/*.rb'].
      map{|f| File.basename(f).gsub('.rb','')}.
      delete_if{|i| i == 'version'}.
      delete_if{|i| i == 'gff_record_helper'}.
      map{|i| " " * 2 + i}.
      join("\n") + "\n"
  end

end
