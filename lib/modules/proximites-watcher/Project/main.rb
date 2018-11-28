class Scrivener
  class Project

    attr_accessor :last_document_mtime

    # = main =
    #
    # Lancement de la surveillance des proximités
    #
    def exec_watch_proximites
      Scrivener.require_module('lib_proximites')
      Debug.init
      ask_for_ouverture
      init_watch_proximites
      options_conformes
      Proximite.init
      output_tableau_etat # pour le mettre en place
      check_etat_proximites_et_affiche_differences
      exec_boucle_surveillance
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /exec_watch_proximites

    # Dans un premier temps on doit s'assurer que les options sont conformes
    # Ici, il faut avoir un document.
    def options_conformes
      self.watched_document_title = CLI.options[:document]
      # Le document doit avoir été précisé dans les options
      watched_document_title || begin
        raise_unfound_binder_item('Il faut indiquer le nom (ou le début du nom du document) à l’aide de l’option `-doc/--document="<nom>"`.')
      end
      # Le document précisé dans les options (partiellement ou entièrement)
      # doit vraiment exister
      # Cela consiste à rechercher en même temps les trois binder-items qui
      # devront être considérés.
      get_binder_items_required
    end
    # /options_conformes

    # Méthode qui définit les trois binder-items à prendre en compte
    # Noter que le titre du document a pu être donné partiellement
    def get_binder_items_required
      CLI.dbg("-> Scrivener::Project#get_binder_items_required (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      self.watched_binder_items = get_binder_items_around(self.watched_document_title)

      # debug('Binder-item surveillé : « %s »' % watched_document_title)
      # debug("Binder-items retenus : #{self.watched_binder_items.collect{|bi|bi.title}}")
      CLI.dbg("<--- Scrivener::Project#get_binder_items_required (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    end
    # /get_binder_items_required

  end #/Project
end #/Scrivener
