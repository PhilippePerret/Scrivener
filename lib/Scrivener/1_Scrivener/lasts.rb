=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener
class << self

  # Retourne le path du dernier projet scrivener
  def last_project_data
    unless last_projects_data.empty?
      last_projects_data.last
    else
      Hash.new
    end
  end

  # Sauve les données +data+ du projet courant
  def save_project_data data
    CLI.debug_entry
    data[:path] = File.expand_path(data[:path])
    data.merge!(saved_at: Time.now)
    # Il ne faut pas répéter plusieurs fois un même projet
    @last_projects_data = last_projects_data.collect do |dprojet|
      dprojet[:path] == data[:path] && next
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
  end
  # Pour remontrer les informations du dernier projet utilisé
  def last_projects_data
    @last_projects_data ||= begin
      if File.exists?(last_projects_path_file)
        Marshal.load(File.open(last_projects_path_file,'rb'))
      else
        Array.new
      end
    end
  end
  def save_last_projects_data
    # File.open(last_projects_path_file,'wb'){|f| Marshal.dump(last_projects_data, f)}
    Marshal.dump(last_projects_data, File.open(last_projects_path_file,'wb'))
  end
  def last_projects_path_file
    @last_projects_path_file ||= File.join(APPFOLDER,'.last_projects_data')
  end

  def init_last_projects_data # pour les tests
    @last_projects_data = nil
  end

end #/<< self
end #/Scriver
