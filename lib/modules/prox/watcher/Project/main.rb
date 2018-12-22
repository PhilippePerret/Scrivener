class Scrivener
class Project

  attr_accessor :last_document_mtime

  # = main =
  #
  # Lancement de la surveillance des proximités
  #
  def exec_watch_proximites
    Scrivener.require_module('TextAnalyzer')
    Scrivener.require_module('lib/proximites')
    # ask_for_ouverture # TODO À REMETTRE
    options_conformes
    TextAnalyzer::Analyse::TableResultats::Proximite.init(self.analyse)
    get_binder_items_around(self.watched_document_title)
    output_tableau_etat # pour le mettre en place
    check_etat_proximites_et_affiche_differences
    exec_boucle_surveillance
    sleep 20
  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
  end
  # /exec_watch_proximites

  # Dans un premier temps on doit s'assurer que les options sont conformes
  # Ici, il faut avoir un document.
  def options_conformes
    self.watched_document_title = CLI.options[:document]
    watched_document_title || begin
      raise_unfound_binder_item('Il faut indiquer le nom (ou le début du nom du document) à l’aide de l’option `-doc/--document="<nom>"`.')
    end
  end
  # /options_conformes

end #/Project
end #/Scrivener
