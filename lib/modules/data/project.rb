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
      puts String::RC*3
      iproj.display_data
      puts String::RC*3
    end
    # /exec_data_projet

  end #/<< self

  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def display_data
    puts String.console_delimitor('=')
    puts 'Titre complet : « %s »' % self.title
    puts 'Path          : %s' % self.path.relative_path
    puts '(pour plus d’infos, taper `scriv infos`)'
    puts String.console_delimitor

    # Pour pouvoir fonctionner, il faut que le projet ait déjà été
    # analysé. Sinon, on demande à l'utilisateur de lancer l'analyse puis
    # de revenir ici.
    # Le projet est analysé lorsque son dossier tableau_proximites existe.
    analysed? || begin
      puts (ERRORS_DATA[:not_analyzed] % [self.title]).rouge
      return
    end

    # On recharge toutes les données du projet
    Scrivener.require_module('lib/proximites/common')
    reload_all_data_project

    # On recharge tout ce qu'il faut pour l'affichage des data
    Scrivener.require_module('lib/output/Data')
    self.output_data
    
  end

  def analysed?
    File.exists?(self.path_proximites)
  end

end #/Project
end #/Scrivener
