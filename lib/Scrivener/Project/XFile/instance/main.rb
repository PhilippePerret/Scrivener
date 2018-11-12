# encoding: UTF-8
require 'fileutils'

class Scrivener
  class Project
    class XFile

      # Le projet Scrivener::Project auquel appartient le
      # projet.
      attr_reader :project

      def initialize project
        @project = project
      end

      # Pour enregistrer le texte modifié
      def save
        File.exist?(copy_path) && File.unlink(copy_path)
        FileUtils.move(path, copy_path)
        xmldoc.write(output: File.open(path, 'w'), indent: 2, transitive: true)
        File.exist?(path) && File.unlink(copy_path)
      end

      def path
        @path ||= project.xfile_path
      end

      def copy_path
        @copy_path ||= File.join(project.path, '%s-backup.scrivx' % project.affixe)
      end

    end #/XFile
  end #/Project
end #/Scrivener
