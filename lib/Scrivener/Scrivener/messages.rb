# encoding: UTF-8
class Scrivener

  ERRORS_MSGS = {
    unknown_command: 'La commande `%s` est inconnue. Utiliser `scriv commands` pour obtenir la liste des commandes et `scriv <command> -h` pour obtenir de l’aide sur une commande particulière.'
  }

  ERRORS = Hash.new

  NOTICES = Hash.new
  NOTICES.merge!(
    require_project_closed: 'Cette opération nécessite que le projet soit absolument fermé.'
  )
  
  class << self

    # Méthode appelée pour afficher l'aide définie dans le
    # message +message+
    def help message
      puts <<-EOT


#{('-'*80).jaune}
#{message}

#{('-'*80).jaune}


      EOT
    end

  end #/<< self
end #/Scrivener
