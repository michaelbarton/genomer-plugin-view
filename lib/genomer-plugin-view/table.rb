require 'genomer'

class GenomerPluginView::Table < Genomer::Plugin

  def run
    ">Feature\t#{flags[:identifier]}\tannotation_table\n"
  end

end
