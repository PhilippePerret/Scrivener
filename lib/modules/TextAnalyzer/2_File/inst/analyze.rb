# encoding: UTF-8
class TextAnalyzer
class File

  # Note : attention, la propriété `analyse` existe, c'est l'instance
  # de l'analyse contenant le fichier.
  def proceed_analyse
    puts "\n\n*** Je procède à l'analyse du fichier #{path}"
    # TODO Il faut ajouter ce fichier (son path) à la table des
    # résultats, pour pouvoir le récupére plus tard

    # = Relève des mots dans le fichier =
    releve_mots
  end

  # Raccourci
  def releve_mots
    texte.releve_mots(analyse.table_resultats)
  end

end #/File
end #/TextAnalyzer
