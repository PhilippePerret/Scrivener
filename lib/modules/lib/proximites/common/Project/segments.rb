=begin

  Module gérant de façon commune les données du tableau de proximités
  à commencer par la méthode qui charge le dernier tableau enregistré
  pour le projet courant.

=end

class Scrivener
  class Project

    attr_accessor :segments # tous les segments de texte, même les ponctuations

    def reload_segments
      CLI.dbg("-> Scrivener::Project#reload_segments (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.open(path_segments,'rb'){|f| Marshal.load(f)}
    end

  end #/Project
end #/Scrivener
