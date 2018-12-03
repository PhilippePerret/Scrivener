# encoding: UTF-8
#
# version 1.3.1
#
# Note version 1.3.1
#   Ajout de la couleur noir sur blanc (noirsurblanc)
# Note version 1.3.0
#   Méthode String.rgb pour mettre n'importe quelle couleur en console.
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

  def as_human_date(options = nil)
    Time.at(self).to_i.as_human_date(options)
  end
  def as_date(options=nil)
    Time.at(self).to_i.as_date(options)
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
