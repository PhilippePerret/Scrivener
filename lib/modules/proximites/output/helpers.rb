class Scrivener
class Project
class Console
class << self

  attr_accessor :nombre_proximites_corriged

  # L'entête de la fenêtre, contenant l'ID de la proximité courante,
  # le nombre total, etc.
  def header_with_data iprox, indice_proximite, nombre_proximites
    ("##{iprox.id}".rjust(9)) + " | #{nb_total_proximites_header} | #{nombre_proximites_corriged_formated} | #{nb_total_proximites_reste} | #{iprox.mot_avant.canonique.ljust(15)} | #{indice_proximite.to_s.rjust(9)} | #{nombre_proximites.to_s.rjust(12)} |"
  end

  def prepare_header_up_window win
    win.clear # pour passer en fond blanc
    entete_label = "PROXIMITÉ | NB TOTAL | CORRIGÉ |  RESTE  | TERME CANONIQUE | INDICE P. | NB P. DU MOT |"
    win.affiche(entete_label, line: 0, style: :bleu)
    @ligne_sous_header_infos = '–'*entete_label.length
    win.affiche(@ligne_sous_header_infos, line: 2, style: :bleu)
  rescue Exception => e
    win.addstr(e.message)
  end


  def ligne_sous_header_infos
    @ligne_sous_header_infos
  end
  def nombre_total_proximites
    @nombre_total_proximites ||= tableau[:proximites].count
  end
  def nb_total_proximites_header
    @nb_total_proximites_header ||= nombre_total_proximites.to_s.rjust(8)
  end
  def nb_total_proximites_reste
    @nb_total_proximites_reste ||= begin
      nombre_proximites_corriged || self.nombre_proximites_corriged = 0
      (nombre_total_proximites - nombre_proximites_corriged).to_s.rjust(7)
    end
  end

  def nombre_proximites_corriged_formated
    @nombre_proximites_corriged_formated ||= nombre_proximites_corriged.to_s.rjust(7)
  end

  def panneau_nomenclature
    <<-EOT
    Espace (ou toute autre touche non fonctionnelle) : proximité suivante
    j : proximité précédente          l/n  : mot suivant      p : mot précédent
    x : supprimer proximité courante        X : supprimer le mot courant
    q : finir
    EOT
  end


end #/self
end #/Console
end #/Project
end #/Scrivener
