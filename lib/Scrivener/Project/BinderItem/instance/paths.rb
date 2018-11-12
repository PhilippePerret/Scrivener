# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem



      # Le fichier RTF dans le projet Scrivener
      def rtf_text_path
        @rtf_text_path ||= File.join(project.data_files_folder_path,uuid,'content.rtf')
      end

      # Le fichier SimpleText dans le dossier de la command (.scriv/files/)
      def simple_text_path
        @simple_text_path ||= File.join(project.hidden_files_folder, "#{uuid}.txt")
      end


    end #/BinderItem
  end #/Project
end #/Scrivener
