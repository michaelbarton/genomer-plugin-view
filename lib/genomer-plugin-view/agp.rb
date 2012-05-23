require 'genomer'

class GenomerPluginView::Agp < Genomer::Plugin

  def run
    header = "##agp-version	2.0"
    entries.unshift(header).join("\n") + "\n"
  end

  def locations(seq,regex)
    seq.upcase.enum_for(:scan, regex).map do
      (Regexp.last_match.begin(0)+1)..(Regexp.last_match.end(0))
    end
  end

  def entries
    cumulative_length  = 1
    count   = 0
    contigs = 0

    scaffold.map do |entry|
      case entry.entry_type
      when :unresolved then
        length = entry.sequence.length
        count += 1
        start = cumulative_length
        stop  = cumulative_length += length
        gap(start, stop - 1, count, 'specified')
      when :sequence   then
        seq = entry.sequence.upcase
        seq_regions = locations(seq,/[^N]+/).map{|i| [:contig,i]}
        gap_regions = locations(seq,/N+/).map{|i| [:gap,i]}
        entries = (seq_regions + gap_regions).sort_by{|_,loc| loc.to_a}

        entries.map do |(type,location)|
          count += 1
          length = (location.end - location.begin)
          entry = case type
                  when :contig then
                    contigs += 1
                    contig(length, cumulative_length, count, contigs)
                  when :gap    then
                    start = cumulative_length
                    stop  = cumulative_length + length
                    gap(start, stop, count, 'internal')
                  end
          cumulative_length += length + 1
          entry
        end
      end
    end
  end

  def contig(length, cum, count, no)
    %W|scaffold #{cum} #{cum + length} #{count} W #{sprintf("contig%05d",no)} 1 #{length+1} +| * "\t"
  end

  def gap(start, stop, count, type)
    %W|scaffold #{start} #{stop} #{count} N #{stop - start + 1} scaffold yes #{type}| * "\t"
  end

end
