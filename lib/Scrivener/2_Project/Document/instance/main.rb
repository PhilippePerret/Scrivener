# encoding: UTF-8
=begin
  Les méthodes qui concerne un "document" scrivener, c'est-à-dire un item,
  soit un document texte, soit un dossier, etc.
=end
class Scrivener
  class Project
    class Document

      attr_reader :project, :data

      # Instanciation d'un document pour le projet +project+ avec les
      # données éventuelles +data+ (Hash)
      def initialize project, data = nil
        @project  = project
        @data     = data
      end

    end #/Document
  end #/Project
end #/Scrivener
