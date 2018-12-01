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
    # OU
    # `scriv prox[ path] idoc=<indice document>`
    #
    # Donc le document peut être spécifié par son titre ou par son numéro
    # dans le dossier manuscrit.
    #
    # +document_title+ peut être transmis à la méthode, comme c'est le cas
    # pour voir par exemple le document le plus dense et le moins dense.
    # Sinon, on le recherche par l'option :document ou le paramètre :doc
    def exec_proximites_one_doc document_title = nil
      init_prox_one_doc
      document_title && self.watched_document_title = document_title
      define_self_data # binder-items checkés, etc.
      self.tableau_proximites = check_proximites_in_watched_binder_items
      Scrivener::Console::Output.affiche_en_deux_pages(self, watched_binder_item)
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
      # Quand on veut voir le document le plus dense ou le moins dense, on
      # appelle ce module avec le titre déjà défini.
      self.watched_document_title || begin
        if CLI.params[:idoc] # <= indice 1-start de document fourni
          # Il faut trouver le document
          CLI.params[:doc] = all_binders[CLI.params[:idoc].to_i - 1].title
        end
        self.watched_document_title = CLI.params[:doc] || CLI.options[:document] || raise_no_document
      end
      self.watched_binder_items = get_binder_items_around(watched_document_title)
    end

    def raise_no_document
      raise('Le titre du document du mot doit être donné (en paramètre : `doc="<début titre>"` ou en option : `-doc="<début titre>"`)')
    end


  end #/Project
end #/Scrivener
