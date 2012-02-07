require 'bio'

module GenomerPluginView::GffRecordHelper

  GFF_TO_TABLE = {
    'gene' => {
      'ID'   => 'locus_tag',
      'Name' => 'gene'
    },
    'CDS'  => {
      'ID'         => 'protein_id',
      'protein_id' => 'protein_id',
    }
  }

  def negative_strand?
    self.strand == '-'
  end

  def coordinates
    if negative_strand?
      [self.end,self.start,self.feature]
    else
      [self.start,self.end,self.feature]
    end
  end

  def to_genbank_feature_row
    out = [coordinates]
    attributes.each do |atr|
      out << process(atr)
    end
    out
  end

  def process(attr)
    key, value = attr
    case key
    when 'ID'   then ['locus_tag', value]
    when 'Name' then ['gene', value]
    else return attr
    end
  end

  def to_genbank_table_entry
    delimiter = "\t"
    indent    = delimiter * 2

    entries = attributes.inject([coordinates]) do |array,atr|
      array << atr.unshift(indent)
    end
    return entries.map{|line| line * delimiter} * "\n" + "\n"
  end

  def attributes
    super.map do |(k,v)|
      k = GFF_TO_TABLE[feature][k]
      k.nil? ? nil : [k,v]
    end.compact
  end

end

Bio::GFF::GFF3::Record.send(:include, GenomerPluginView::GffRecordHelper)
