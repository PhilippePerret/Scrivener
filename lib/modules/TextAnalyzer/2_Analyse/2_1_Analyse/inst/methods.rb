# encoding: UTF-8
class TextAnalyzer
class Analyse

  # RETURN true si tous les fichiers d'analyse (Marshal) existent (et peuvent
  # donc être rechargés)
  def exist?
    texte_entier.exist? && table_resultats.exist?
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
