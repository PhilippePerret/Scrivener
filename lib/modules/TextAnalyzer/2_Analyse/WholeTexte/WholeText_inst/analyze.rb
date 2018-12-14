# encoding: UTF-8
class TextAnalyzer
class Analyse
class WholeText

  # Note : attention, la propriété `analyse` existe, c'est l'instance
  # de l'analyse contenant le fichier.
  def proceed_analyse
    CLI.debug_entry

    # = Lemmatisation du texte =
    lemmatize

    # = Relève des mots dans le fichier =
    # cf. fichier 'releve_mots.rb'
    releve_mots

    # = On recherche les proximités =
    # cf. fichier 'proximites.rb'
    search_proximites

  end



end #/WholeText
end #/Analyse
end #/TextAnalyzer
