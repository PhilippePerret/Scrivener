# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
class << self
  LINE_LAST_PROJET = '  %s. %s %s'

  # = main =
  #
  # Permet de récupérer la liste des derniers projets
  def exec_last_projects
    CLI.debug_entry
    any_project? || begin
      return wt('projects.errors.none')
    end
    lines = Array.new
    lines << t('list.cap.sing of.cap.plur last.cap.plur project.cap.plur')
    lines << '='.ljust(lines.first.length,'=')
    lines << separator
    expected_keys = Array.new
    expected_keys << 'q' #pour renoncer
    last_projects_data.each_with_index do |dprojet, idx|
      findex = (97+idx).chr
      expected_keys << findex
      lines << LINE_LAST_PROJET % [findex, ftitle(dprojet), dprojet[:path].relative_path]
    end
    lines << separator
    lines << ' '*4 + t('projects.notices.last_is_current', {title: title_for(last_projects_data.last)})
    lines << ''

    # On écrit la liste
    CLI::Screen.clear
    puts  INDENT + lines.join(String::RC+INDENT) + String::RC*2

    # S'il y a plus d'un projet, on demande lequel choisir
    if last_projects_data.count > 1
      # On attend le choix
      if t = getc(t('projects.invites.project_to_choose'), {expected_keys: expected_keys})
        t != 'q' || return
        data_projet = last_projects_data[t.ord - 97]
        save_project_data(data_projet)
        wt('projects.notices.project_chosen', {title: title_for(data_projet)})
      end
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
