# encoding: UTF-8
class Scrivener
  class Project

    # Le fichier <projet>.scriv/<projet>.scrivx du projet Scrivener
    def xfile
      @xfile ||= XFile.new(self)
    end


  end #/Project
end #/Scrivener
