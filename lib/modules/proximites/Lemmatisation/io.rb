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

    # Rechargement de la table TABLE_LEMMATISATION
    def reload_table_lemmatisation
      CLI.dbg("-> Scrivener::Project#reload_table_lemmatisation (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.open(path_table_lemmatisation,'rb'){|f| Marshal.load(f)}
    end

    # Fichier caché, au niveau du projet scrivener, contenant la table de
    # lemmatisation propre au texte.
    def path_table_lemmatisation
      @path_table_lemmatisation ||= File.join(project.hidden_folder, 'table_lemmatisation.msh')
    end

    def lemma_data_path
      @lemma_data_path ||= File.join(project.hidden_folder, 'lemmatisation_all_data')
    end

  end #/Project
end #/Scrivener
