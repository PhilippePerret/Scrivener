class Scrivener
class Project
  class << self

    # = main =
    #
    # Méthode principale pour afficher le maximum de données sur
    # le projet.
    #
    def exec_infos_last_projet
      d = Scrivener.last_project_data
      if d.empty?
        return wt('projects.errors.none')
      else
        project.display_infos(d)
      end
    end
    # /exec_data_projet

  end #/<< self

  # ---------------------------------------------------------------------
  #   MÉTHODES D'INSTANCE

  def display_infos(last_data)
    tempvalues = {
      separation:   '-'*(self.path.relative_path.length + 18),
      full_title:   self.title || '---',
      short_title:  self.title_abbreviated || '---',
      authors:      get_authors_or_neant,
      access:       self.path.relative_path,
      created_at:   last_data[:created_at].to_i.as_human_date,
      saved_at:     last_data[:saved_at].to_i.as_human_date,
      command:      last_data[:last_command],
      options:      last_data[:options].collect{|o, v| "--#{o}[=#{v.inspect}]"}.join
    }
    wt('projects.pannels.infos', tempvalues, {air: true})
  end

  def get_authors_or_neant
    unless self.authors.empty?
      self.authors.collect{|d|"#{d[:firstname]} #{d[:lastname]}".strip}.pretty_join(inspect: false)
    else
      '---'
    end
  end
end #/Project
end #/Scrivener
