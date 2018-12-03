=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener
  class << self

    attr_accessor :command
    attr_accessor :project_path

    # = main =
    #
    # On exécute la commande
    # (dans le contexte du dossier où on se trouve)
    # -------------------
    def run

      # # Pour faire des tests sans lancer l'application
      # puts '-- CLI.params: %s' % CLI.params.inspect
      # return

      if command_on_project?(self.command)
        # On n'est pas forcément dans le dossier du projet, comme par exemple
        # lorsqu'on réutilise la dernière path utilisée.
        Dir.chdir(project.folder) do
          require File.join(APPFOLDER,'lib','commands',self.command)
        end
      else
        # Si ce n'est pas un commande sur projet, inutile de se place
        # dans le dossier du projet.
        require File.join(APPFOLDER,'lib','commands',self.command)
      end
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
      # puts e.message.rouge
      # puts e.backtrace[0..2].join("\n").rouge
    end


    # ---------------------------------------------------------------------
    #   Méthodes accessoire

    def save_current_informations
      Project.save_project_data(
        last_command:   self.command,
        path:           self.project_path,
        options:        CLI.options,
        created_at:     Time.now
        )
    end

    # ---------------------------------------------------------------------
    #   Méthodes des tests

    def test_project_if_command_on_project
      command_on_project?(self.command) || return
      Project.must_exist(self.project_path)
      # On peut écrire le path du projet
      puts 'Projet : %s' % project_path
    end

    # Retourne true si la commande est une vraie commande, c'est-à-dire autre
    # chose que l'aide ou la liste des commandes demandées
    def command_on_project?(commande)
      @is_real_command ||= begin
        !(NOT_ON_PROJECT_COMMANDS.include?(commande) || CLI.options[:help])
      end
    end

    # Retourne true si la commande +commande+ existe.
    def command_exist?(commande)
      File.exist?(File.join(APPFOLDER,'lib','commands',"#{commande}.rb"))
    end
  end #/<< self
end #/Scriver