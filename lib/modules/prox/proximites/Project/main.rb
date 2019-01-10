class Scrivener
class Project

  attr_accessor :watched_binder_item_uuid

  # = main =
  #
  # Méthode qui reçoit dans tous les cas la commande `scriv prox `
  def exec_proximites
    CLI.debug_entry

    Scrivener.require_module('Scrivener')
    Scrivener.require_module('TextAnalyzer')

    if CLI.params.key?(:abbreviations)
      TextAnalyzer.open_file_abbreviations
    elsif CLI.params.key?(:mot)
      # => Il faut n'afficher que la proximité d'un mot
      Scrivener.require_module('prox/one_word')
      exec_proximites_one_word
    elsif CLI.params.key?(:doc) || CLI.params.key?(:idoc)
      # => Il ne faut afficher que la proximité d'un document
      Scrivener.require_module('prox/one_doc')
      exec_proximites_one_doc
    elsif CLI.options[:maxtomin] || CLI.options[:mintomax]
      Scrivener.require_module('prox/max_to_min')
      exec_max_to_min
    else
      # Sinon, c'est l'affichage de toutes les proximités
      if CLI.options[:data]
        Scrivener.require_module('data')
        Scrivener::Project.exec_data_projet(self)
      else
        unless output_proximites
          wt('notices.abort_', nil, {color: :rouge})
        end
      end
    end
  ensure
    CLI.debug_exit
  end
  # /exec_proximites

  # Méthode principale qui checke les proximités
  #
  def output_proximites
    CLI.debug_entry
    # Scrivener.require_module('lib/proximites/common')

    # = C'EST ICI QU'ON RÉCUPÈRE LES DONNÉES D'ANALYSE =
    get_data_analyse || return

    # Sortie en console
    if CLI.options[:in_file]
      build_proximites_scrivener_file
    elsif CLI.options[:data]
      build_and_display_tableau_resultat_proximites
    elsif CLI.options[:only_calculs]
      something_is_displayed = false
      if CLI.options[:segments]
        # LAISSER CES puts ! Ils font partie du programme
        puts "\n\n\n---- #{t('segment.cap.plur')}: \n#{analyse.segments.inspect}"
        something_is_displayed = true
      end
      if CLI.options[:proximites]
        # LAISSER CES puts ! Ils font partie du programme
        puts "\n\n\n---- #{t('proximity.cap.plur')}: "
        something_is_displayed = true
      end
      something_is_displayed || wt('commands.proximity.notices.opt_with_only_calculs', nil, {color: :rouge})
    else
      analyse.output.all unless CLI.options[:no_output]
    end
    return true
  ensure
    CLI.debug_exit
  end


end #/Project
end #/Scrivener
