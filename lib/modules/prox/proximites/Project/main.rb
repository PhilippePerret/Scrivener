class Scrivener
  class Project

    attr_accessor :watched_binder_item_uuid

    attr_accessor :tableau_proximites

    # = main =
    #
    # Méthode qui reçoit dans tous les cas la commande `scriv prox `
    def exec_proximites
      CLI.debug_entry
      Debug.init

      Scrivener.require_module('analyse')
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
            puts ' Abandon…'.rouge
          end
        end
      end
      CLI.debug_exit
    end
    # /exec_proximites

    # Méthode principale qui checke les proximités
    #
    def output_proximites
      CLI.debug_entry
      Scrivener.require_module('lib/proximites/common')
      get_data_proximites || return
      # Sortie en console
      if CLI.options[:in_file]
        build_proximites_scrivener_file
      elsif CLI.options[:data]
        build_and_display_tableau_resultat_proximites
      elsif CLI.options[:only_calculs]
        something_is_displayed = false
        if CLI.options[:segments]
          # LAISSER CES puts ! Ils font partie du programme
          puts "\n\n\n---- SEGMENTS: \n#{segments.inspect}"
          something_is_displayed = true
        end
        if CLI.options[:proximites]
          # LAISSER CES puts ! Ils font partie du programme
          puts "\n\n\n---- PROXIMITÉS: "
          something_is_displayed = true
        end
        something_is_displayed || puts("Avec --only_calculs, il faut ajouter une option pour voir une liste (--segments, --proximites, etc.)".rouge)
      else
        analyse.output.all
      end
    end


    def check_proximites
      CLI.dbg("-> Scrivener::Project#check_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # On procède à la relève
      binder_items.each do |bitem|
        bitem.treate_proximite(self.tableau_proximites)
      end

      # On peut sauver la liste des segments textuels du projet
      save_segments
      # Note : les proximités seront sauvées après leur calcul.

      # On traite les proximités
      calcul_proximites(self.tableau_proximites)

      return true
    end
    #/check_proximites

  end #/Project
end #/Scrivener
