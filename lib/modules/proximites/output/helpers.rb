class Scrivener
class Project
class Console
class << self

  # L'entête de la fenêtre, contenant l'ID de la proximité courante,
  # le nombre total, etc.
  def header_with_data iprox, pointeurs
    indice_proximite_mot  = pointeurs[:mot] + 1
    nombre_proximites_mot = pointeurs[:nombre_proximites_mot]

    human_id = "##{iprox.id}".rjust(9)
    mot_canon     = iprox.mot_avant.canonique.ljust(15)

    [
      human_id,
      mot_canon,
      indice_proximite_mot.to_s.rjust(11),
      nombre_proximites_mot.to_s.rjust(14),
      '',
      nb_total_proximites_header,
      human_nombre_prox_fixed,
      nb_total_proximites_reste
    ].join(' | ') + ' |'
  end

  def prepare_header_up_window win
    win.clear # pour passer en fond blanc
    # entete_label = "PROXIMITÉ | NB TOTAL | CORRIGÉ |  RESTE  | TERME CANONIQUE | INDICE P. | NB P. DU MOT |"
    entete_label = "PROXIMITÉ | TERME CANONIQUE | INDICE PROX | NB PROX DU MOT |  | TOTAL PROX | CORRIGÉES |  RESTE  |"
    win.affiche(entete_label, line: 0, style: :bleu_sur_blanc)
    @ligne_sous_header_infos = '–'*entete_label.length
    win.affiche(@ligne_sous_header_infos, line: 2, style: :bleu_sur_blanc)
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
    @nb_total_proximites_header ||= nombre_total_proximites.to_s.rjust(10)
  end
  def nb_total_proximites_reste
    @nb_total_proximites_reste ||= begin
      nombre_proximites_corriged || self.nombre_proximites_corriged = 0
      (nombre_total_proximites - nombre_proximites_corriged).to_s.rjust(7)
    end
  end

  def nombre_proximites_corriged
    @nombre_proximites_corriged ||= begin
      tb = tableau # protect.tableau_proximites
      tb[:nombre_proximites_erased]   +
      tb[:nombre_proximites_fixed]    +
      tb[:nombre_proximites_ignored]  -
      tb[:nombre_proximites_added]
    end
  end
  def human_nombre_prox_fixed
    @human_nombre_prox_fixed ||= nombre_proximites_corriged.to_s.rjust(9)
  end

  def panneau_nomenclature
    <<-EOT
    Espace (ou toute autre touche non fonctionnelle) : proximité suivante
    j : proximité précédente          l/n  : mot suivant      p : mot précédent
    x : supprimer proximité courante        X : supprimer le mot courant
    c : corriger la proximité courante
    q : finir
    EOT
  end


end #/self
end #/Console
end #/Project
end #/Scrivener
