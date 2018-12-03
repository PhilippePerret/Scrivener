=begin

  Module gérant de façon commune les données du tableau de proximités
  à commencer par la méthode qui charge le dernier tableau enregistré
  pour le projet courant.

=end

TABLE_LEMMATISATION = Hash.new

class Scrivener
  class Project

    # Rechargement de la table TABLE_LEMMATISATION
    def reload_table_lemmatisation
      CLI.dbg("-> Scrivener::Project#reload_table_lemmatisation (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.open(path_table_lemmatisation,'rb'){|f| Marshal.load(f)}
    end

  end #/Project
end #/Scrivener
