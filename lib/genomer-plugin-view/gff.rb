require 'genomer'

class GenomerPluginView::Gff < Genomer::Plugin

  DEFAULT = '.'

  def run
    options = GenomerPluginView.convert_command_line_flags(flags)
    annotations(options).
      map{|i| i.seqname = options[:identifier] || DEFAULT; i}.
      map(&:to_s).
      map(&:strip).
      unshift("##gff-version 3").
      join("\n") + "\n"
  end

end
