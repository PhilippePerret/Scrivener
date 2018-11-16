=begin

  Toutes les méthodes Scrivener::Project utiles pour la lemmatisation
  du texte.

=end
class Scrivener
  class Project


    # Méthode qui prépare la lémmatisation.
    # Synopsis :
    #   - reconstitution de la totalité du texte dans un fichier unique
    #   - traitement des lèmmes de ce fichier pour produire un fichier data
    #     dont chaque ligne contient l'information sur les mots.
    #   - lecture de ce fichier de données pour produire une table de
    #     correspondance propre au texte (table[<mot>] => <mot canonique>)
    #     Cette table s'appelle la TABLE_LEMMATISATION
    #   - Enregistrement de cette table de lémmisation pour utilisation
    #     ultérieure sans avoir à tout relire.
    #
    # Noter que le fichier data contient d'autres informations comme par
    # exemple la nature du mot.
    def lemmatize from_path, to_path
      CLI.dbg("-> Scrivener::Project#lemmatize (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # Ensuite, il faut prendre ce texte et en tirer les données de
      # lemmatisation complètes, qui seront mises dans .scriv/lemmatisation_data
      CLI.benchmark(:start, 'Lemmatisation du texte')
      `tree-tagger-french < #{from_path} > #{to_path} 2>/dev/null`
      CLI.benchmark(:stop)

    end
    # /prepare_lemmatisation

  end #/Project
end #/Scrivener
