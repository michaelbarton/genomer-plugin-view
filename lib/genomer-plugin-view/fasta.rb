require 'genomer'

class GenomerPluginView::Fasta < Genomer::Plugin

  def run
    if flags[:contigs]
      flags.delete(:contigs)

      sequence.
        split(/[Nn]+/).
        map{|s| Bio::Sequence.new(s) }.
        each_with_index.
        map{|s,i| s.output(:fasta,:header => header(sprintf("contig%05d",i+1))) }.
        join
    else
      Bio::Sequence.new(sequence).output(:fasta,:header => header(identifier))
    end
  end

  def header(identifier)
    (identifier + ' ' + header_flags).strip
  end

  def identifier
    flags[:identifier] ? flags.delete(:identifier) : '.'
  end

  def header_flags
    flags.map{|k,v| "[#{k}=#{v}]" }.join(' ')
  end

  def sequence
    scaffold.map{|entry| entry.sequence}.join
  end

end
