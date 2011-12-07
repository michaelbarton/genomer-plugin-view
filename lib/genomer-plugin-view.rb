require 'genomer'

class GenomerPluginView < Genomer::Plugin

  def run
    s = scaffold.map{|entry| entry.sequence}.join
    Bio::Sequence.new(s).output(:fasta)
  end

end
