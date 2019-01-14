=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener
class << self

  # Retourne les données du dernier projet, mais en vérifiant qu'il
  # existe bien encore
  # TODO
  def last_existant_project
    Scrivener.last_project_data
  end

  # Retourne le path du dernier projet scrivener
  def last_project_data
    unless last_projects_data.empty?
      last_projects_data.last
    else
      Hash.new
    end
  end

  # Sauve les données +data+ du projet courant
  # +data+ Hash contenant :
  #   :path       Le path absolu vers le projet (.scriv)
  #               Si non défini (au départ, quand le fichier des derniers
  #               n'existe pas et qu'aucun projet n'a été spécifié — mais on
  #               ne génère pas d'erreur car ça peut être une commande sans
  #               projet, comme l'aide)
  #   :title      Le titre du projet
  #   :saved_at   [Sera ajouté ici] La date d'enregistrement comme
  #               projet courant.
  def save_project_data data
    CLI.debug_entry
    data[:path]   || return
    data[:title]  || return
    data[:path] = File.expand_path(data[:path])
    data.merge!(saved_at: Time.now)
    # Il ne faut pas répéter plusieurs fois un même projet
    # On en profite aussi pour passer les projets qui n'existent plus
    @last_projects_data = last_projects_data.collect do |dprojet|
      dprojet[:path] == data[:path] && next
      (dprojet[:path] && File.exist?(dprojet[:path])) || next
      dprojet
    end.compact
    # Dans tous les cas, qu'on ait ou non trouvé le projet, on
    # le met à la fin pour qu'il soit celui par défaut à la prochaine
    # utilisation de la commande.
    last_projects_data << data
    if last_projects_data.count > 10
      last_projects_data = last_projects_data[-10..-1]
    end
    save_last_projects_data
    CLI.debug_exit
  end
  # Pour remontrer les informations du dernier projet utilisé
  def last_projects_data
    @last_projects_data ||= get_last_projects_data
  end

  # On récupère la liste des derniers projets dans le fichier se trouvant
  # dans le dossier ./scriv dans le $HOME de l'utilisateur. Un check est
  # fait pour rejeter les projets dont le :title est nil, mais maintenant
  # ils ne devraient plus pouvoir être enregistrés.
  def get_last_projects_data
    CLI.debug_entry
    if File.exists?(last_projects_path_file) && File.stat(last_projects_path_file).size > 0
      File.open(last_projects_path_file,'rb'){|f| Marshal.load(f)}.reject{|dp| dp[:title].nil?}
    else
      Array.new
    end
  ensure
    CLI.debug_exit
  end
  def save_last_projects_data
    CLI.debug_entry
    lastdata = last_projects_data # pour qu'il ne soit pas ouvert
    File.open(last_projects_path_file,'wb'){|f| Marshal.dump(lastdata, f)}
    CLI.debug_exit
  end
  def last_projects_path_file
    @last_projects_path_file ||= File.join(HOME_FOLDER,'.last_projects_data')
  end

  # Pour les tests
  def init_last_projects_data
    @last_projects_data       = nil
    @last_projects_path_file  = nil
  end

end #/<< self
end #/Scriver
