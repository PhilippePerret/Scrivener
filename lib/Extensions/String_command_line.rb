# encoding: UTF-8
#
# version 1.2.2
#

class String

  PAGE_WIDTH        = 1500.0
  NOMBRE_MOTS_PAGE  = 250

  RC = <<-EOT

  EOT

  CHIFFRE_HAUT = {
    0 => '⁰',
    1 => '¹',
    2 => '²',
    3 => '³',
    4 => '⁴',
    5 => '⁵',
    6 => '⁶',
    7 => '⁷',
    8 => '⁸',
    9 => '⁹'
  }
  CHIFFRE_BAS = {
    0 => '₀',
    1 => '₁',
    2 => '₂',
    3 => '₃',
    4 => '₄',
    5 => '₅',
    6 => '₆',
    7 => '₇',
    8 => '₈',
    9 => '₉'
  }


  # Attention : retourne un Array des lignes ajustées
  def self.truncate str, line_len, options = nil
    options ||= Hash.new
    truncate_and_justify(str, line_len, options.merge!(justify: false))
  end

  def self.truncate_and_justify str, line_len, options = nil
    options ||= Hash.new
    options.key?(:justify) || options.merge!(justify: true)
    # Les lignes qui seront renvoyées
    lines = Array.new
    paragraphes = str.split(String::RC)
    paragraphes.each do |paragraphe|

      # Si le paragraphe est inférieur à la largeur de la ligne,
      # on peut le mettre en ligne et passer au suivant
      paragraphe.length > line_len || begin
        lines << paragraphe
        next
      end

      # Maintenant, on fait des lignes de la bonne longueur
      mots = paragraphe.split(/[  ]/)

      paragraphe_lines = Array.new
      begin
        mots_line = Array.new
        while mots.first && ((mots_line).join(' ') + " #{mots.first}").length < line_len
          mots_line << mots.shift
        end
        # puts "mots_line: #{mots_line.inspect} / len = #{mots_line.join(' ').length}"
        options[:justify] || mots_line = mots_line.join(' ')
        paragraphe_lines << mots_line
      end until mots.empty?

      if options[:justify]
        # On justifie toutes les lignes sauf la dernière
        paragraphe_lines[0..-2].each_with_index do |mots_line, index_line|
          # Justifier
          final_line = justify(mots_line, line_len)
          paragraphe_lines[index_line] = final_line
        end
        paragraphe_lines[-1] = paragraphe_lines[-1].join(' ')
      end #/ justify

      lines << paragraphe_lines.join("\n")
    end

    return lines
  end

  # On justifie la ligne +line+ à la longueur +line_width+
  def self.justify(line, line_width)
    line.is_a?(Array) || line = line.split(' ')
    imot = 0
    nombre_mots = line.count

    while line.join(' ').strip.length < line_width
      imot += 1
      line[ -imot ] += ' '
      imot < nombre_mots || imot = 0
    end
    return line.join(' ')
  end

  # truncate le texte
  def segmente longueur, heading = ''
    li  = Array.new
    # Il faut traiter le cas où le texte contient des retours chariots
    self.split(RET).each do |seg|
      while seg.length > longueur
        ri = seg.rindex(' ', longueur)
        ri || break
        li << seg[0..ri]
        seg = seg[ri+1..-1]
      end
      seg.length > 0 && li << seg
    end
    return heading + li.join("\n#{heading}")
  end

  # Le texte en bleu gras pour le terminal
  def bleu_gras
    "\033[1;96m#{self}\033[0m"
  end
  # Le texte en bleu gras pour le terminal
  def bleu
    "\033[0;96m#{self}\033[0m"
    # 96=bleu clair, 93 = jaune, 94/95=mauve, 92=vert
  end

  def mauve
    "\033[1;94m#{self}\033[0m"
  end

  def fond1
    "\033[38;5;8;48;5;45m#{self}\033[0m"
  end
  def fond2
    "\033[38;5;8;48;5;40m#{self}\033[0m"
  end
  def fond3
    "\033[38;5;0;48;5;183m#{self}\033[0m"
  end
  def fond4
    "\033[38;5;15;48;5;197m#{self}\033[0m"
  end
  def fond5
    "\033[38;5;15;48;5;172m#{self}\033[0m"
  end

  def jaune
    "\033[0;93m#{self}\033[0m"
  end

  def vert
    "\033[0;92m#{self}\033[0m"
  end

  # Le texte en rouge gras pour le terminal
  def rouge_gras
    "\033[1;31m#{self}\033[0m"
  end

  # Le texte en rouge gras pour le terminal
  def rouge
    "\033[0;91m#{self}\033[0m"
  end

  def rouge_clair
    "\033[0;35m#{self}\033[0m"
  end

  def gris
    "\033[0;90m#{self}\033[0m"
  end

  # Le texte en gras pour le terminal
  def gras
    "\033[1m#{self}\033[0m"
  end

  # Le string dont on a retiré les couleurs
  def sans_couleur
    self.gsub(/\e\[(.*?)m/,'').gsub(/\\e\[(.*?)m/,'')
  end
  # Méthode qui strip la chaine courante mais renvoie NIL si elle est vide.
  def strip_nil
    s = self.strip
    s == '' ? nil : s
  end

  # Self est de la forme JJ/MM/YYYY et la méthode renvoie le
  # nombre de secondes correspondantes
  def as_seconds
    jrs, mois, ans = self.split('/').collect{|e| e.strip.to_i}
    return Time.new(ans, mois, jrs, 0,0,0).to_i
  end
  alias :to_seconds :as_seconds

  def underlined with = '-', heading = ''
    return "#{self}\n#{heading}#{with * self.length}"
  end


  # Transformer les caractères diacritiques et autres en ASCII
  # simples
  unless defined? DATA_NORMALIZE
    DATA_NORMALIZE = {
      :from => "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
      :to   => "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz"
    }
  end
  # ou def normalized
  def normalize
    self
      .force_encoding('utf-8')
      .gsub(/[œŒæÆ]/,{'œ'=>'oe', 'Œ' => 'Oe', 'æ'=> 'ae', 'Æ' => 'Ae'})
      .tr(DATA_NORMALIZE[:from], DATA_NORMALIZE[:to])
  end
  alias :normalized :normalize

end
