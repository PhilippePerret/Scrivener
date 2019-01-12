class Scrivener
class Project
  class << self

    # = main =
    #
    # Méthode principale pour afficher le maximum de données sur
    # le projet.
    #
    def exec_data_projet(iproj)
      Scrivener.require_module('TextAnalyzer')
      Scrivener.require_module('prox/proximites')
      CLI::Screen.clear
      iproj.display_data
      # puts iproj.build_graph_densites # TODO Remettre plus tard
    end
    # /exec_data_projet

  end #/<< self

  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def display_data
    arr = Array.new
    arr << String.console_delimitor('=')
    arr << t('full_title.tit.sing').ljust(20) + FRENCH_SPACE + ': ' + self.title
    arr << t('path.tit.sing').ljust(20) + FRENCH_SPACE + ': ' + self.path.relative_path
    arr << t('notices.pour_plus_dinfos_')
    arr << String.console_delimitor
    puts INDENT + arr.join(String::RC + INDENT)
    # On recharge toutes les données du projet ou on les calcule
    get_data_analyse || return
    self.analyse.output.all
  end

end #/Project
end #/Scrivener
