# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
class << self
  LINE_LAST_PROJET = '    %s. %s %s'
  # = main =
  #
  # Permet de récupérer la liste des derniers projets
  def exec_last_projects
    CLI.debug_entry
    any_project? || begin
      return wt('projects.errors.none')
    end
    lines = Array.new
    lines << INDENT+'LISTE DES DERNIERS PROJETS'
    lines << (INDENT+'=').ljust(lines.first.length,'=')
    lines << separator
    expected_keys = Array.new
    expected_keys << 'q' #pour renoncer
    last_projects_data.each_with_index do |dprojet, idx|
      expected_keys << idx.to_s
      findex = idx.to_s.rjust(2)
      lines << LINE_LAST_PROJET % [findex, ftitle(dprojet), dprojet[:path].relative_path]
    end
    lines << separator
    lines << '  (le dernier projet — « %s » — est le projet courant)' % [title_for(last_projects_data.last)]

    # On écrit la liste
    CLI::Screen.clear
    puts  lines.join(String::RC) + String::RC*2

    # On attend le choix
    if t = getc('Projet à choisir (son index — ou "q" pour renoncer) : ', {expected_keys: expected_keys})
      t != 'q' || return
      data_projet = last_projects_data[t.to_i]
      save_project_data(data_projet)
      puts "Le projet « #{title_for(data_projet)} » a été mis en dernier projet. Vous pouvez utiliser les commandes `scriv` sans indiquer ce projet."
    end
  end

  def separator
    @separator ||= CLI.separator({tab: '  ', return: false})
  end
  def ftitle(dprojet)
    title_for(dprojet).ljust(30)
  end
  def title_for(dprojet)
    dprojet[:title] || dprojet[:path].split(File::SEPARATOR)[-2..-1].join(File::SEPARATOR)
  end

  # Retourne true s'il y a des projets précédents (le fichier existe et
  # il contient des projets)
  def any_project?
    File.exist?(Scrivener.last_projects_path_file) && last_projects_data.any?
  end

end #/<< self
end
