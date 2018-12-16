# encoding: UTF-8
class TextAnalyzer
class Analyse

  # = main =
  #
  # Rechargement de l'analyse, c'est-à-dire :
  #   - de la table de résultat
  #   - de l'instance du texte entier (et donc des mots)
  def reload
     (self.texte_entier.exist? && self.table_resultats.exist?)|| begin
      self.exec
      return
    end
    # Les données du texte entier
    @texte_entier = TextAnalyzer::Analyse::WholeText.load(self)
    # La table de résultats
    @table_resultats = TextAnalyzer::Analyse::TableResultats.load(self)
  end

end #/Analyse
end #/TextAnalyzer
