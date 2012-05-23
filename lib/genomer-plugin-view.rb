require 'genomer'

class GenomerPluginView < Genomer::Plugin

  def run
    self.class.fetch_view(arguments.shift).new(arguments,flags).run
  end

  def self.fetch_view(view)
    require 'genomer-plugin-view/' + view
    const_get(view.capitalize)
  end

end
