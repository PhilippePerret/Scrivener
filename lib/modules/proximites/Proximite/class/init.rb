class Proximite
class << self

  # = Initialisation de l'application =
  def init
    prepare_liste_rectifiees
    prepare_liste_proximites_projet
  end

  # Initialise et retourne une table de proximités qui contiendra tous
  # les résultats
  def init_table_proximites(iprojet = nil)
    iprojet ||= project
    tableau = Hash.new
    tableau.merge!(
      current_offset:     0,
      current_index_mot:  -1,
      mots:               Hash.new, # tous les mots traités
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


  def prepare_liste_rectifiees
    h = PROXIMITES_MAX
    hash_mots = Hash.new
    h.each do |k_distance, liste_mots|
      liste_mots.each {|mot| hash_mots.merge!(mot => k_distance)}
    end
    PROXIMITES_MAX[:mots] = hash_mots
    #/fin de boucle sur toutes les distances rectifiées
  end
  # /prepare_liste_rectifiees


  def prepare_liste_proximites_projet
    File.exists?(project.proximites_file_path) || return

    proximite_maximale = -1
    File.open(project.proximites_file_path,'rb').each do |line|
      line.start_with?('#') && next
      if line =~ /[0-9]+/
        proximite_maximale = line.to_i
      else
        PROXIMITES_MAX[:mots].merge!(line => proximite_maximale)
      end
    end
  end
  # /traite_listes_projet

end #/ << self
end #/Proximite
