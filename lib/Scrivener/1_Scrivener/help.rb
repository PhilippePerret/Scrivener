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
    message = INDENT + message.gsub(/(\r?\n)/, '\1'+INDENT)
    CLI::Screen.less(message)
    CLI.debug_exit
  end

  # Retourne true si c'est l'aide qui est demandé
  def help?
    CLI.options[:help]
  end

end #/<< self
end #/Scrivener
