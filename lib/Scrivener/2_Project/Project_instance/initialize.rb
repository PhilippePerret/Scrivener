# encoding: UTF-8
class Scrivener
  class Project

    # Instanciation d'un nouveau projet Scrivener
    # Il s'agit du projet complet, le paquet entier. On peut ensuite
    # prendre chaque élément du paquet par `.mainfile` (le fichier scrivx),
    # etc.
    def initialize path
      puts "-- INSTANCIATION AVEC : #{path.inspect}"
      @path = File.expand_path(path)
      # Le cas échéant, on construit son dossier caché (et le dossier files)
      `mkdir -p "#{hidden_files_folder}"`
    end

  end #/Project
end #/Scrivener
