# encoding: UTF-8
class Scrivener
  class Project
    class XFile

      # Méthode qui doit vider le dossier manuscrit
      # Cela consiste en :
      #   1. détruire le fichier du dossier Files (par UUID)
      #   2. détruire l'item XML dans le xfile
      def empty_draft_folder
        draftfolder.elements['Children'] || return
        draftfolder.elements['Children'].elements[1] || return
        while draftfolder.elements['Children'].delete_element(1)
          # TODO Détruire aussi le dossier
        end
      end


    end #/XFile
  end #/Project
end #/Scrivener
