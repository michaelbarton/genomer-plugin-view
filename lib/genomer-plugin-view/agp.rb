require 'genomer'

class GenomerPluginView::Agp < Genomer::Plugin

  def run
    header = "##agp-version	2.0"
    entries = contigs.map.with_index do |ctg,i|
      %W|scaffold 1 #{ctg.length} #{i+1} W #{sprintf("contig%05d",i+1)} 1 #{ctg.length} +| * "\t"
    end
    entries.unshift(header).join("\n") + "\n"
  end

  def contigs
    scaffold.map{|entry| entry.sequence}.join.split(/[Nn]+/)
  end

end
