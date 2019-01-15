=begin

  Module de démarrage de la commance `scriv`
=end
class Scrivener
  class << self

    # = main =
    #
    # On exécute la commande
    # (dans le contexte du dossier où on se trouve)
    # -------------------
    def run

      # # Pour faire des tests sans lancer l'application
      # puts '-- CLI.params: %s' % CLI.params.inspect
      # return

      Dir.chdir(command_on_project?(self.command) ? project.folder : File.expand_path('.')) do
        require fpath('lib','commands',command)
      end

      # Space between end script and invite
      puts String::RC * 3

    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end

  end #/<< self
end #/Scriver
