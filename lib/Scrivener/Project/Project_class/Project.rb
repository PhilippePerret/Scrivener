class Scrivener
  class Project
    class << self

      # Vérifie que le path +path+ définit bien un projet scrivener valide
      # Dans le cas contraire, raise une erreur
      # Cette méthode est appelée à l'initialisation de la commande.
      def must_exist ppath
        ppath || raise('Il faut définir le projet Scrivener à traiter, en indiquant le chemin depuis votre dossier utilisateur (%s).' % [Dir.home])
        File.extname(ppath) == '.scriv'  || raise('L’extension du projet devrait être «.scriv» (c’est «%s»)' % File.extname(ppath))
        File.exist?(ppath) || raise('Le projet «%s» est introuvable. Merci de vérifier le chemin.' % ppath)
      end

      # Définit la path du projet courant en fonction de la commande
      # et/ou des dernières données enregistrées
      def define_project_path_from_command
        if CLI.params[1] && File.directory?(CLI.params[1])
          dossier = CLI.params[1]
          dossier = dossier[0...-1] if dossier.end_with?('/')
          Dir['%s/*.scriv' % dossier].first
        elsif CLI.params[1] && !CLI.params[1].index('=')
          CLI.params[1]
        else
          Dir['./*.scriv'].first || self.last_project_path
        end
      end

      # Retourne le path du dernier projet scrivener
      def last_project_path
        # puts "--- dernier path : #{last_project_data[:path].inspect}"
        last_project_data[:path]
      end
      def save_project_data data
        data[:path] = File.expand_path(data[:path])
        data.merge!(saved_at: Time.now)
        save_last_project_data(data)
      end
      # Pour remontrer les informations du dernier projet utilisé
      def last_project_data
        @last_project_data ||= begin
          if File.exists?(project_path_file)
            File.open(project_path_file,'rb'){|f| Marshal.load(f)}
          else
            Hash.new
          end
        end
      end
      def save_last_project_data(data)
        File.open(project_path_file,'wb'){|f| Marshal.dump(data, f)}
      end
      def project_path_file
        @project_path_file ||= File.join(APPFOLDER,'.last_project_data')
      end
    end #/<< self
  end #/Project
end #/Scrivener
