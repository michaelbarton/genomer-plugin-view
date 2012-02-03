require 'bio'

module GenomerPluginView::GffRecordHelper

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
    coordinates * "\t" + "\n"
  end

end

Bio::GFF::GFF3::Record.send(:include, GenomerPluginView::GffRecordHelper)
