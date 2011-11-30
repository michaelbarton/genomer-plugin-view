class GenomerPluginView

  def initialize(scaffold,options)
    @scaffold = scaffold
    @options  = options
  end

  def run
    s = @scaffold.map{|entry| entry.sequence}.join
    Bio::Sequence.new(s).output(:fasta,:header => @options[:identifier])
  end

end
