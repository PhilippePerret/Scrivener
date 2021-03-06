# encoding: UTF-8
module ModuleFormatageTdm

  class Scrivener::Project::TDM
    # Méthode principale qui va sortir la table des matières dans le
    # format voulu.
    def output_table_of_content
      # Et pour le moment, on l'affichage comme ça
      strtdm = [
        *lines,
        String::RC * 2,
        '(%s)' % [t('helps.notices.scriv_command', {cmd: CLI.command_init})]
      ].join(String::RC)
      ecrit(strtdm)
    end

    # Pour ajouter les lignes de titre
    def add_lines_titre
      lines << '  ' + projet.title.upcase
      lines << '  ='.ljust(lines[0].length, '=')
      lines << '  TABLE DES MATIÈRES'
      lines << ''
    end

    def tdm_file_path
      @tdm_file_path ||= project.tdm_file_path('txt')
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
