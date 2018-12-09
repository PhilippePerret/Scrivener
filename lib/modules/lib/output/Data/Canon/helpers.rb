=begin

  Classe Scrivener::Project::Canon
  Méthodes d'helper

=end
class Scrivener
class Project
class Canon

  DEMI_COLONNE_CANON = '%{fcanon} | x %{focc} |%{aster} %{fprox} p. | %{fdensite} | %{fmoydist} s.'

  # Méthode principale qui retourne le canon formaté sur une demi colonne
  # grâce au template DEMI_COLONNE_CANON
  def line_demi_colonne
    DEMI_COLONNE_CANON % {
      fcanon:     formated_canon,
      focc:       formated_occurences,
      fprox:      formated_proximites,
      aster:      (distance_minimale != Proximite::DISTANCE_MINIMALE ? '*' : ' '),
      fdensite:   formated_densite,
      fmoydist:   formated_moyenne_distance
    }
  end

  def formated_canon
    @formated_canon ||= canon.ljust(20)
  end
  def formated_occurences
    @formated_occurences ||= nombre_occurences.to_s.ljust(5)
  end
  def formated_proximites
    @formated_proximites ||= nombre_proximites.to_s.rjust(5)
  end
  def formated_densite
    @formated_densite ||= pourcentage_densite.ljust(6)
  end
  def pourcentage_densite
    @pourcentage_densite ||= (nombre_proximites.to_f / nombre_occurences).pourcentage
  end
  def formated_moyenne_distance
    @formated_moyenne_distance ||= begin
      moyenne_distances.to_s.rjust(5)
    rescue Exception => e
      '[ERR. CALC: %s]' % e.message
    end
  end
end #/Canon
end #/Project
end #/Scrivener
