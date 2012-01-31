require 'genomer'

class GenomerPluginView::Fasta < Genomer::Plugin

  def run
    s = scaffold.map{|entry| entry.sequence}.join
    Bio::Sequence.new(s).output(:fasta,:header => header)
  end

  def header
    text = flags[:identifier] ? flags.delete(:identifier) : '. '
    text << flags.map{|k,v| "[#{k}=#{v}]" } * ' '
  end

end
