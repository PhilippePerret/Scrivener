class Proximite
class << self
  # Initialise et retourne une table de proximités qui contiendra tous
  # les résultats
  def init_table_proximites(iprojet = nil)
    iprojet ||= project
    tableau = Hash.new
    tableau.merge!(
      current_offset:     0,
      current_index_mot:  -1,
      # Table de tous les mots traités avec en clé la forme canonique
      # et en valeur les instances de ProxMot
      mots:               Hash.new,
      # Table de mots différents avec en clé le mot et en valeur la liste
      # des indices de chaque occurence
      real_mots:          Hash.new,
      proximites:         Hash.new,
      binder_items:       Hash.new, # tous les binder-items
      project_path:       iprojet.path,
      # Nombres
      last_id_proximite:            0,
      nombre_proximites_erased:     0,
      nombre_proximites_fixed:      0,
      nombre_proximites_ignored:    0,
      nombre_proximites_added:      0,
      # Dates (surtout pour la commande `proximites`)
      modified_at:    nil, # ou date de dernière modification
      created_at:     Time.now,
      last_saved_at:  nil
    )
    return tableau
  end
  # /init_table_proximites
end #/ << self
end #/Proximite
