=begin
  Module principal pour l'affichage des proximités d'un seul mot
=end
class Scrivener
  class Project

    # Le mot dont il faut voir la proximité
    attr_accessor :mot
    # Instance ProxMot du mot
    attr_accessor :proxmot

    def exec_proximites_one_word

      init_prox_one_word
      define_self_data # mot, document, etc.

      # On cherche les proximités dans les binder-items concernés
      self.tableau_proximites = check_proximites_in_watched_binder_items

      # Pour pouvoir traiter le mot, il faut qu'on en trouve la valeur
      # canonique
      self.tableau_proximites || return
      self.proxmot = ProxMot.new(mot)
      if self.tableau_proximites[:mots].key?(proxmot.canon)
        Output.affiche_en_deux_page(self, proxmot)
      else
        puts "Impossible de trouver le mot #{mot} (#{proxmot.canon})"
      end


    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /exec_proximites_one_word


    # Initialisation de la commande
    def init_prox_one_word
      Scrivener.require_module('lib_proximites')
      Debug.init
    end

    # Définition des données utiles
    # À commencer par le mot dont il faut voir les proximités et
    # les documents concernés.
    def define_self_data
      self.mot = CLI.params[:mot]
      # Note : le mot existe forcément puisque c'est lorsqu'il est défini
      # qu'on vient dans ce module.
      self.watched_document_title = CLI.params[:doc] || CLI.options[:document] || raise_no_document
      self.watched_binder_items = get_binder_items_around(watched_document_title)
    end

    def raise_no_document
      raise('Le titre du document du mot doit être donné (en paramètre : `doc="<début titre>"` ou en option : `-doc="<début titre>"`)')
    end

  end #/Project
end #/Scrivener
