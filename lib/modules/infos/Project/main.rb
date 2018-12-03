class Scrivener
class Project
  class << self

    # = main =
    #
    # Méthode principale pour afficher le maximum de données sur
    # le projet.
    #
    def exec_infos_last_projet
      d = last_project_data
      if d.empty?
        puts 'Aucun projet n’a été analysé pour le moment. Utilisez `scriv -h` pour obtenir de l’aide ou même `scriv` seul.'
      else
        project.display_infos(d)
      end
    end
    # /exec_data_projet

  end #/<< self

  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def display_infos(last_data)
    puts 'Titre complet : %s' % self.title
    puts 'Titre court   : %s' % self.title_abbreviated
    puts 'Auteurs       : %s' % [self.authors.pretty_join]
    puts '-'*80
    puts 'Dernière commande jouée : %s %s' % [last_data[:last_command], last_data[:options].collect{|o, v| "--#{o}[=#{v.inspect}]"}.join]
    puts 'Date de création        : %s' % [last_data[:created_at].to_i.as_human_date]
    puts 'Date d’enregistrement   : %s' % [last_data[:saved_at].to_i.as_human_date]
    puts '-'*80
  end

end #/Project
end #/Scrivener