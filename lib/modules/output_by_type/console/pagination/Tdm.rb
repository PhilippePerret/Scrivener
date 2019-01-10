# encoding: UTF-8
module ModuleFormatageTdm

  class Scrivener::Project::TDM
    # Méthode principale qui va sortir la table des matières dans le
    # format voulu.
    def output_table_of_content
      CLI::Screen.clear
      puts INDENT + [
        *lines,
        String::RC * 2,
        '(%s)' % [t('helps.notices.scriv_command', {cmd: CLI.command_init})]
      ].join(String::RC + INDENT)

    end

    # Pour ajouter les lignes de titre
    def add_lines_titre
      lines << projet.title.upcase
      lines << '=' * lines[0].length
      lines << t('table_of_contents.cap.sing')
      lines << ''
    end


    # Pour la compatibilité avec les autres formats
    def tdm_file_path
      @tdm_file_path ||= nil
    end

  end#/Scrivener
end#/Module
