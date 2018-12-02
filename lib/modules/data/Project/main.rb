class Scrivener
class Project
  class << self

    # = main =
    #
    # Méthode principale pour afficher le maximum de données sur
    # le projet.
    #
    def exec_data_projet(iproj)
      iproj.display_data
    end
    # /exec_data_projet

  end #/<< self

  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def display_data
    puts 'Titre complet : %s' % self.title
    puts 'Titre court   : %s' % self.title_abbreviated
    puts '(note : les titres se règlent dans la fenêtre de compilation)'
    puts 'Auteurs       : %s' % ['TODO Liste des auteurs ']
  end

end #/Project
end #/Scrivener
