class Scrivener
class Project

  ERRORS_DATA = {
    not_analyzed: 'Ce projet « %s » n’a pas encore été analysé. Impossible d’afficher ses données. Jouer la commande `scriv prox` pour procéder à son analyse.'
  }

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
      puts String::RC*3
    end
    # /exec_data_projet

  end #/<< self

  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def display_data
    puts String.console_delimitor('=')
    puts '  Titre complet : « %s »' % self.title
    puts '  Path          : %s' % self.path.relative_path
    puts '  (pour plus d’infos, taper `scriv infos`)'
    puts String.console_delimitor
    # On recharge toutes les données du projet ou on les calcule
    get_data_analyse || return
    self.analyse.output.all
  end

end #/Project
end #/Scrivener
