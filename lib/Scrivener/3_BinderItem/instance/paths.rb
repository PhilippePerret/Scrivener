# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem

      # Construction, au besoin, du dossier du fichier dans Data/Files/
      def build_data_file_folder
        `mkdir -p "#{data_file_folder}"`
        File.exist?(data_file_folder) || raise('Le dossier « %s » aurait dû être créé.' % data_file_folder)
        CLI.dbg('= Dossier « %s » créé avec succès.' % data_file_folder)
      end


      # Le fichier RTF dans le projet Scrivener
      def rtf_text_path
        @rtf_text_path ||= File.join(projet.data_files_folder_path,uuid,'content.rtf')
      end
      # Sert par exemple lorsque l'on crée le binder-item programmatiquement
      def txt_text_path
        @txt_text_path ||= File.join(projet.data_files_folder_path,uuid,'content.txt')
      end
      def markdown_text_path
        @markdown_text_path ||= File.join(projet.data_files_folder_path,uuid,'content.md')
      end

      # Le fichier SimpleText dans le dossier de la command (.scriv/files/)
      def simple_text_path
        @simple_text_path ||= File.join(projet.hidden_files_folder, "#{uuid}.txt")
      end

      def data_file_folder
        @data_file_folder ||= File.expand_path(File.join(projet.data_files_folder_path,uuid))
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
