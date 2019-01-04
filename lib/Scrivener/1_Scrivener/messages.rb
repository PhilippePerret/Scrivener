# encoding: UTF-8
class Scrivener
class << self

  # Méthode appelée pour afficher l'aide définie dans le
  # message +message+
  #
  # Maintenant, la commande fonctionne comme less, en
  # affichant juste ce qu'il faut pour la fenêtre
  def help message
    CLI.debug_entry
    CLI::Screen.less(message)
    CLI.debug_exit
  end

end #/<< self
end #/Scrivener
