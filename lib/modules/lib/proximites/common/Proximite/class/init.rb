class Proximite
class << self

  # = Initialisation de l'application =
  def init
    # On initialise les listes de proximité
    prepare_liste_rectifiees
    prepare_liste_proximites_projet
  end
  # /init

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

  # Préparation de la liste des mots propre au projet, à distance particulière
  def prepare_liste_proximites_projet
    File.exists?(project.proximites_file_path) || begin
      debug 'Pas de liste proximités propre au projet (le fichier %s n’existe pas)' % project.proximites_file_path
      return
    end

    debug '* Ajout des mots à proximité propre au projet…'
    proximite_maximale = -1
    File.open(project.proximites_file_path,'rb').each do |line|
      line.start_with?('#') && next
      if line =~ /[0-9]+/
        proximite_maximale = line.to_i
      else
        mot = line.strip.downcase
        debug '   = Ajout du mot %s à la distance %i' % [mot.inspect, proximite_maximale]
        PROXIMITES_MAX[:mots].merge!(mot => proximite_maximale)
      end
    end
  end
  # /prepare_liste_proximites_projet

end #/ << self
end #/Proximite
