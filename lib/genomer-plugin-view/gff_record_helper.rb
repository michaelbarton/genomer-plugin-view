require 'bio'

module GenomerPluginView::GffRecordHelper

  GFF_TO_TABLE = {
    'gene' => {
      'ID'   => 'locus_tag',
      'Name' => 'gene'
    },
    'CDS'  => {
      'ID'        => 'protein_id',
      'Name'      => 'product',
      'Note'      => 'note',
      'ec_number' => 'EC_number',
      'function'  => 'function',
    },
    'ncRNA' => { 'product' => 'product' },
    'rRNA'  => { 'product' => 'product' },
    'tmRNA' => { 'product' => 'product' },
    'tRNA'  => { 'product' => 'product', 'Note' => 'note' }
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

  def to_genbank_table_entry

    delimiter = "\t"
    indent    = delimiter * 2

    entries = table_attributes.inject([coordinates]) do |array,atr|
      array << atr.unshift(indent)
    end
    return entries.map{|line| line * delimiter} * "\n" + "\n"
  end

  def valid?
    GFF_TO_TABLE.include?(feature)
  end

  def table_attributes
    raise Genomer::Error, "Unknown feature type '#{feature}'" unless valid?
    attributes.map do |(k,v)|
      k = GFF_TO_TABLE[feature][k]
      k.nil? ? nil : [k,v]
    end.compact
  end

end

Bio::GFF::GFF3::Record.send(:include, GenomerPluginView::GffRecordHelper)
