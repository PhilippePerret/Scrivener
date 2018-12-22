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
    check_proximites_in_watched_binder_items
    self.analyse.exist? || return
    imot = TextAnalyzer::Analyse::TableResultats::Mot.new(mot)
    if analyse.table_resultats.canons.key?(imot.canon)
      self.analyse.output.affiche_en_deux_pages(mot)
    else
      puts ERRORS_MSGS[:unfound_word] % [mot, imot.canon]
    end

  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
  end
  # /exec_proximites_one_word


  # Initialisation de la commande
  def init_prox_one_word
  end

  # Définition des données utiles
  # À commencer par le mot dont il faut voir les proximités et
  # les documents concernés.
  # Note : le mot existe forcément puisque c'est lorsqu'il est défini
  # qu'on vient dans ce module.
  def define_self_data
    self.mot = CLI.params[:mot]
    self.watched_document_title = CLI.params[:doc] || CLI.options[:document] || raise_no_document
    self.watched_binder_items = get_binder_items_around(watched_document_title)
  end

  def raise_no_document
    raise(ERRORS_MSGS[:document_title_required])
  end

end #/Project
end #/Scrivener
