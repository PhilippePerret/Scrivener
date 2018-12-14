# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  # = main =
  #
  # Méthode principale qui répertorie les proximités dans le texte complet.
  # Pour ce faire, on se sert des canons et des offsets de mots
  def search_proximites
    CLI.debug_entry
    # puts '-- canons : ' + analyse.table_resultats.canons.inspect
    analyse.table_resultats.canons.each do |canon, hcanon|
      hcanon[:items].each do |imot|
        
      end
    end
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
