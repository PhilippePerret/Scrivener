# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # Affichage/sortie des mots
  def mots opts = nil
    defaultize_options(opts)
    data.mots.each_with_index do |mot, index_mot|
      puts "mot #{index_mot}: #{mot}"
    end
  end
  # /mots

  def liste_mots_uniques opts = nil
    defaultize_options(opts)
    data.liste_mots_uniques.each_with_index do |mot, index_mot|
      puts "mot unique #{index_mot.to_s.ljust(3)}: #{mot[0]}"
    end
  end
  # /liste_mots_uniques

  # Affichage/sortie des canons
  def canons opts = nil
    defaultize_options(opts)
    data.canons.values.each_with_index do |icanon, index_canon|
      icanon.as_line_output
    end
  end
  # /canons

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
