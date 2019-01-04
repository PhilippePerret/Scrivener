# encoding: UTF-8
class Scrivener
class << self

  # Méthode appelée pour afficher l'aide définie dans le
  # message +message+
  def help message
    CLI.debug_entry
    CLI::Screen.clear
    puts <<-EOT


#{('-'*80).jaune}
#{message}

#{('-'*80).jaune}


    EOT
    CLI.debug_exit
  end

end #/<< self
end #/Scrivener
