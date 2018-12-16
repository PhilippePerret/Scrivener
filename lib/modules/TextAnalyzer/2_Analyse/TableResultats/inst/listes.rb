# encoding: UTF-8
=begin
  Pour définir des listes
=end
class TextAnalyzer
class Analyse
class TableResultats

  # Un mot unique est un mot qui
  # n'est employé qu'une seule fois. Ce nombre ne tient pas compte des
  # forme canonique. Si "auraient" apparait une fois, la présence de "avoir"
  # ou "aurait" ne changer rien à son unicité
  def liste_mots_uniques
    @liste_mots_uniques ||= begin
      mots.select do |mot, imot|
        imot.count == 1
      end
    end
  end

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
