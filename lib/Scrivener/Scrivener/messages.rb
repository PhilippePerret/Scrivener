# encoding: UTF-8
class Scrivener
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
