# encoding: UTF-8
=begin
  Les méthodes qui concerne un "document" scrivener, c'est-à-dire un item,
  soit un document texte, soit un dossier, etc.
=end
class Scrivener
  class Project
    class Document

      def content_path
        @content_path ||= File.join(project.data_files_folder_path,'content.rtf')
      end

      def synopsis_path
        @synopsis_path ||= File.join(project.data_files_folder_path,'synopsis.txt')
      end

    end #/Document
  end #/Project
end #/Scrivener
