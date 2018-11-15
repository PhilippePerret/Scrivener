# encoding: UTF-8
class Scrivener
  class Project

    def affixe
      @affixe ||= File.basename(path, File.extname(path))
    end

    def xfile_path
      @xfile_path ||= File.join(path,'%s.scrivx' % affixe)
    end

    def files_folder_path
      @files_folder_path ||= File.join(path, 'Files')
    end
    def data_files_folder_path
      @data_files_folder_path ||= File.join(files_folder_path, 'Data')
    end

    def quicklook_folder_path
      @quicklook_folder_path ||= File.join(path, 'Quicklook')
    end

    def settings_folder_path
      @settings_folder_path ||= File.join(path, 'Settings')
    end

    # Dossier caché contenant tous les fichiers utiles aux opérations de la
    # commande `scriv` courante
    def hidden_folder
      @hidden_folder ||= File.join(folder,'.scriv')
    end
    # Dossier caché contenant tous les fichiers texte simplifiés
    def hidden_files_folder
      @hidden_files_folder ||= File.join(hidden_folder,'files')
    end

    # Dossier contenant le fichier principal du projet scrivener
    def folder
      @folder ||= File.dirname(path)
    end

  end #/Project
end #/Scrivener
