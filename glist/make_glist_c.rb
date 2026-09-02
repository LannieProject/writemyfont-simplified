require 'json'
require 'set'

$aglfn = Hash.new(false)
f = File.open('aglfn.txt', 'r:utf-8')
f.each { |s|
	s.chomp!
	next if s == ''
	next if s[0] == '#'

	uni, name, d = s.split(/;/, 3)
	$aglfn[uni.to_i(16)] = name
}
f.close

Wmap = {'比例'=>'P', '半形'=>'H', '全形'=>'F'}
GlyphInfo = Struct.new(:name, :seq, :width, :note, :vert, :seqs, :full, :cnt) do
	def sort_val
		if seq.length == 1
			sprintf('%06X', seq.ord)
		else
			name =~ /uni([A-Z0-9]{4}\.vert)/ ? name.gsub(/^uni/, '00') : name
		end
	end

	def to_json(*_args)
		h = { c: seq, w: Wmap[width] }
		h[:n] = note if note
		h[:v] = vert if vert
		h[:s] = seqs if seqs
		h[:f] = full if full
		h.to_json
	end
end

$glist = {}
$cmap = Hash.new(nil)
$fulls = Set.new()

def read_list fn, ctype, col=nil
	list = {}
	lastno = nil
	f = File.open(fn, 'r:utf-8')
	f.each { |s|
		s.chomp!
		next if s == ''
		next if s !~ /^\d/

		tmp = s.split(/\t/)
		no = tmp[0].to_i
		seq = tmp[1]
		uni = tmp[2] != '' ? tmp[2].to_i(16) : nil
		next if col && tmp[col] != 'V'

		if uni && ctype == :HS
			gname = sprintf(uni <= 0xffff ? 'uni%04X' : 'u%05X', uni)
			$glist[gname] = GlyphInfo.new(gname, seq, '全形')
			$cmap[seq] = gname
			list[no] = gname
		elsif uni
			next if tmp[4] == '兩倍全形'
			next if [0x20, 0x2c9, 0x3000, 0xA0, 0x2002].include?(uni)

			gname = $aglfn[uni] || sprintf(uni <= 0xffff ? 'uni%04X' : 'u%05X', uni)
			next if $fulls.include?(gname)

			$glist[gname] = GlyphInfo.new(gname, seq, tmp[4], tmp[5])
			$cmap[seq] = gname

			if tmp[5] =~ /直排/
				$glist[gname].vert = list[lastno]
			elsif gname == 'uniFF1A' || gname == 'uniFF1B'
				$glist[gname].vert = gname
			end

			if (0x30..0x39).include?(uni) || (0x40..0x5A).include?(uni) || (0x61..0x7A).include?(uni)
				$fulls << $glist[gname].full = sprintf('uni%04X', uni + 0xfee0)
				$glist[gname].note.gsub!(/半形/, '') if $glist[gname].note
			end

			list[no] = gname
		elsif seq != ''
			seqs = seq.split(//).map { |c| $cmap[c] }
			gname = seqs.join('_')

			$glist[gname] = GlyphInfo.new(gname, seq, tmp[4], tmp[5])
			$glist[gname].seqs = seqs if seqs.size > 1
			list[no] = gname
		else
			lastg = list[lastno]

			if lastg != 'uniFF1A' && lastg != 'uniFF1B'
				gname = lastg + '.vert'
				$glist[gname] = GlyphInfo.new(gname, $glist[lastg].seq, tmp[4], tmp[5], lastg)
				list[no] = gname
			end
		end

		lastno = no
	}
	f.close

	list.sort_by { |k, v| k }.map { |k, v| v }
end

verybaselist = ('a'..'z').to_a + ('A'..'Z').to_a
verybaselist += ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'comma', 'period', 'hyphen']

baselist = verybaselist + ['uni02CA', 'caron', 'uni02CB', 'dotaccent']
('ㄅ'..'ㄩ').to_a.each { |c| baselist << sprintf('uni%04X', c.ord) }
'一二三四五六七八九十微风迎客软语伴茶，。'.split(//).each { |c| baselist << sprintf('uni%04X', c.ord) }

level1 = read_list('hans_level1.txt', :HS)
level2 = read_list('hans_level2.txt', :HS)
level3 = read_list('hans_level3.txt', :HS)

result_tmp = {
    '基础字' => baselist,
    '基本符号' => read_list('sym_base.txt', :S),
    '简体测试字-50' => read_list('hans_test50.txt', :HS),

    '一级字-3500' => level1,
    '二级字-3000' => level2,
    '三级字-1605' => level3,
}

$glist = $glist.sort_by { |k, v| v.sort_val }.to_h

pagesize = 420
result = {}

result_tmp.each { |k, v|
	puts "Processing #{k} with #{v.size} items"
	puts "  -- #{(v.size * 1.0 / pagesize).ceil} pages with #{v.size % pagesize} items in last page" if v.size > pagesize

	next if v.size == 0

	if v.size > pagesize
		(v.size / pagesize.to_f).ceil.times { |i|
			result["#{k}##{i+1}"] = v[i * pagesize, pagesize]
		}
	else
		result[k] = v
	end
}

f = File.open('../pages/cglyphlist.js', 'w:utf-8')
f.puts "const glyphMap = #{JSON.pretty_generate($glist)};"
f.puts "const glyphList = #{result.to_json};"
f.close
