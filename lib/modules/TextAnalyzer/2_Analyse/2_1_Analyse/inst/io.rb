# encoding: UTF-8
class TextAnalyzer
class Analyse

  def save_all
    table_resultats.save
    texte_entier.save
    data.ended_at = Time.now
    data.save
    self.save
  end
  # /save_all

  # = main =
  #
  # Rechargement de l'analyse, c'est-à-dire :
  #   - de la table de résultat
  #   - de l'instance du texte entier (et donc des mots)
  #   - des données (data)
  #
  # Si l'analyse n'existe pas, on l'exécute à nouveau
  def reload
    self.exist? || (return self.exec)
    # cette analyse elle-même
    self.load
    # Les données de l'analyse
    self.data.load
    # Les données du texte entier
    self.texte_entier.load
    # La table de résultats
    self.table_resultats.load
  end


end #/Analyse
end #/TextAnalyzer
