=begin
  Module pour les méthodes Scrivener::Project pour afficher les
  proximités d'un document
=end
class Scrivener
  class Project

    # = main =
    #
    # Méthode principale appelée par la commande
    # `scriv prox[ path] doc="<document>"`
    def exec_proximites_one_doc
      init_prox_one_doc
      define_self_data # binder-items checkés, etc.
      # On cherche les proximités dans les binder-items concernés
      self.tableau_proximites = check_proximites_in_watched_binder_items
      unless self.tableau_proximites[:proximites].empty?
        Scrivener::Console::Output.affiche_en_deux_pages(self, watched_binder_item)
      else
        puts 'Aucune proximité n’a été trouvée dans ce document.'.bleu
        return
      end
    end


    # Initialisation de la commande
    def init_prox_one_doc
      Scrivener.require_module('lib/proximites/common')
      Scrivener.require_module('lib/output')
      Debug.init
    end


    # Définition des données utiles
    # On cherche les binder-items concernés
    def define_self_data
      self.watched_document_title = CLI.params[:doc] || CLI.options[:document] || raise_no_document
      self.watched_binder_items = get_binder_items_around(watched_document_title)
    end

    def raise_no_document
      raise('Le titre du document du mot doit être donné (en paramètre : `doc="<début titre>"` ou en option : `-doc="<début titre>"`)')
    end


  end #/Project
end #/Scrivener
