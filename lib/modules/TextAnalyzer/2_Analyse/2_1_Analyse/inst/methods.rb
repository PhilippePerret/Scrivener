# encoding: UTF-8
class TextAnalyzer
class Analyse

  # = main =
  #
  # Rechargement de l'analyse, c'est-à-dire :
  #   - de la table de résultat
  #   - de l'instance du texte entier (et donc des mots)
  #
  def reload
    self.exist? || begin
      self.exec
      return
    end
    # Les données de l'analyse
    @data             = TextAnalyzer::Analyse::Data.load(self)
    # Les données du texte entier
    @texte_entier     = TextAnalyzer::Analyse::WholeText.load(self)
    # La table de résultats
    @table_resultats  = TextAnalyzer::Analyse::TableResultats.load(self)
  end

  # RETURN true si tous les fichiers d'analyse (Marshal) existent (et peuvent
  # donc être rechargés)
  def exist?
    self.texte_entier.exist? &&
    self.table_resultats.exist?
  end

  # RETURN true si l'analyse est d'actualité. On peut le savoir seulement si
  # la date `modified_at` du document original a été transmise à l'instanciation
  # Cette date `modified_at` est consignée dans `self.original_doc_modified_at`
  def uptodate?
    self.original_doc_modified_at || (return true)
    self.modified_at || (return true)
    self.modified_at > self.original_doc_modified_at
  end

end #/Analyse
end #/TextAnalyzer
