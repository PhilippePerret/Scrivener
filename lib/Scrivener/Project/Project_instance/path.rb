# encoding: UTF-8
class Scrivener
  class Project

    def affixe
      @affixe ||= File.basename(path, File.extname(path))
    end

    def path_segments
      @path_segments ||= File.join(project.hidden_folder, 'table_segments.msh')
    end

    def path_proximites
      @path_proximites ||= File.join(project.hidden_folder, 'tableau_proximites.msh')
    end

    def whole_text_path
      @whole_text_path ||= File.join(self.hidden_folder,'whole_texte.txt')
    end

    # Fichier caché, au niveau du projet scrivener, contenant la table de
    # lemmatisation propre au texte.
    def path_table_lemmatisation
      @path_table_lemmatisation ||= File.join(project.hidden_folder, 'table_lemmatisation.msh')
    end

    def lemma_data_path
      @lemma_data_path ||= File.join(project.hidden_folder, 'lemmatisation_all_data')
    end

    def xfile_path
      @xfile_path ||= File.join(path,'%s.scrivx' % affixe)
    end

    def ui_common_path
      @ui_common_path ||= File.join(settings_folder_path,'ui-common.xml')
    end

    def compile_file_path
      @compile_file_path ||= File.join(settings_folder_path,'compile.xml')
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

    # Fichier contenant la définition des données de proximité propres
    # au projet courant
    def proximites_file_path
      @proximites_file_path ||= File.join(folder, 'proximites.txt')
    end

    # Dossier contenant le fichier principal du projet scrivener
    def folder
      @folder ||= File.dirname(path)
    end

  end #/Project
end #/Scrivener
