# encoding: UTF-8
module ModuleFormatageTdm

  class Scrivener::Project::TDM
    # Méthode principale qui va sortir la table des matières dans le
    # format voulu.
    def output_table_of_content
      # Et pour le moment, on l'affichage comme ça
      ecrit  lines.join(RET)
    end

    # Pour ajouter les lignes de titre
    # Ici, ça sert simplement à faire la ligne de libellés
    def add_lines_titre
      CLI.debug_entry
      lines << (CLI.options[:no_count] ? TDM_LABELS_SIMPLE : TDM_LABELS)
      CLI.debug_exit
    end

    def tdm_file_path
      @tdm_file_path ||= File.join(project.folder, 'tdm.csv')
    end

    def ecrit str
      rf.write str
    end

    def rf
      @rf ||= begin
        File.unlink(tdm_file_path) if File.exist?(tdm_file_path)
        File.open(tdm_file_path,'a+')
      end
    end

  end#/Scrivener
end#/Module
