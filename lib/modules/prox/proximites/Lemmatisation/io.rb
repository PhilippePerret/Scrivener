=begin

  Toutes les méthodes Scrivener::Project utiles pour la lemmatisation
  du texte.

=end
class Scrivener
  class Project

    # Enregistrement de la table TABLE_LEMMATISATION
    def save_table_lemmatisation
      CLI.dbg("-> Scrivener::Project#save_table_lemmatisation (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.exists?(path_table_lemmatisation) && File.unlink(path_table_lemmatisation)
      File.open(path_table_lemmatisation,'wb'){|f| Marshal.dump(TABLE_LEMMATISATION,f)}
    end


  end #/Project
end #/Scrivener
