require 'genomer'

class GenomerPluginView::Mapping < Genomer::Plugin

  def run
    original = annotations.map(&:id).map(&:clone)
    updated  = annotations(GenomerPluginView.convert_command_line_flags(flags)).map(&:id)

    original.zip(updated).
      map{|i| i.join("\t") }.
      join("\n")
  end

end
