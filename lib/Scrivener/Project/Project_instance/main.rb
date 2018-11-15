# encoding: UTF-8
class Scrivener
  class Project

    attr_reader :path

    # l'UUID du dossier courant dans lequel doit être placé
    # le document courant, ou nil
    attr_accessor :current_folder

    # Instanciation d'un nouveau projet Scrivener
    # Il s'agit du projet complet, le paquet entier. On peut ensuite
    # prendre chaque élément du paquet par `.mainfile` (le fichier scrivx),
    # etc.
    def initialize path
      @path = File.expand_path(path)
      # Le cas échéant, on construit son dossier caché (et le dossier files)
      `mkdir -p "#{hidden_files_folder}"`
    end


  end #/Project
end #/Scrivener
