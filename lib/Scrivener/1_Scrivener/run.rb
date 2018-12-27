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
        CLI.dbg "SUIVI --> . = #{`pwd`}"
        CLI.dbg "SUIVI --> require '%s'" % File.join(APPFOLDER,'lib','commands',self.command)
        require File.join(APPFOLDER,'lib','commands',self.command)
      end

    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end

  end #/<< self
end #/Scriver
