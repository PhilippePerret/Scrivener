class Scrivener
  class Project

    def path_segments
      @path_segments ||= File.join(project.hidden_folder, 'table_segments.msh')
    end

    def path_proximites
      @path_proximites ||= File.join(project.hidden_folder, 'tableau_proximites.msh')
    end

    # Fichier dans lequel enregistrer le tableau des résultats des proximités
    def tbl_proximites_path
      @tbl_proximites_path ||= File.join(project.hidden_folder, 'tableau_affichage_%{all}proximites.txt' % {all: (CLI.options[:all] ? 'all_' : '')})
    end

  end #/Project
end #/Scrivener
