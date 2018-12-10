# encoding: UTF-8
class TextAnalyzer
class File

  # Note : attention, la propriété `analyse` existe, c'est l'instance
  # de l'analyse contenant le fichier.
  def proceed_analyse
    puts "\n\n*** Je procède à l'analyse du fichier #{path}"
    releve_mots
  end

  # Raccourci
  def releve_mots
    texte.releve_mots(analyse.table_resultats)
  end

end #/File
end #/TextAnalyzer
