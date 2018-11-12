# encoding: UTF-8
=begin

Toutes les méthodes permettant de gérer le fichier .scrivx du projet

=end
require 'rexml/document'
class Scrivener
  class Project
    class XFile

      def xmldoc
        @xmldoc ||= REXML::Document.new(File.new(project.xfile_path))
      end

      def root
        @root ||= xmldoc.root
      end

      # {XML Node} Le classeur dans le document XML
      def binder
        @binder ||= root.elements['Binder']
      end

      # {XML Node} Le dossier manuscrit dans le document XML principal
      def draftfolder
        @draft_folder ||= binder.elements["BinderItem[@Type='DraftFolder']"]
      end
      def researchfolder
        @research_folder ||= binder.elements["BinderItem[@Type='ResearchFolder']"]
      end
      def trashfolder
        @trash_folder ||= binder.elements["BinderItem[@Type='TrashFolder']"]
      end

    end #/XFile
  end #/Project
end #/Scrivener
