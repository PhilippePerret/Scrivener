# encoding: UTF-8
class Scrivener
  class Project

    # Le fichier <projet>.scriv/<projet>.scrivx du projet Scrivener
    def xfile
      @xfile ||= XFile.new(self)
    end

    # Pour créer un dossier principal, au niveau supérieur (comme le
    # dossier Manuscrit ou la poubelle)
    def create_main_folder data
      xfile.create_main_folder(data)
    end

    # Pour vider le manuscrit de tous ses documents
    # Attention, l'opération peut être dangereuse, donc on met tous
    # les éléments dans un dossier proche
    def empty_draft_folder
      # On vide les éléments dans le dossier manuscrit dans le
      # fichier XML
      xfile.empty_draft_folder
      # On vide le dossier contenant tous les fichiers
      Dir["#{data_files_folder_path}/*"].each do |el|
        if File.directory?(el)
          FileUtils.rm_rf(el)
        else
          File.unlink(el)
        end
      end
    end


  end #/Project
end #/Scrivener
