# encoding: UTF-8

class Scrivener
  class Project
    class XFile

      # Le projet Scrivener::Project auquel appartient le
      # projet.
      attr_reader :projet

      def initialize projet
        @projet = projet
      end

      # Pour enregistrer le texte modifié
      def save
        File.exist?(copy_path) && File.unlink(copy_path)
        FileUtils.move(path, copy_path)
        xmldoc.write(output: File.open(path, 'w'), indent: 2, transitive: true)
        File.exist?(path) && File.unlink(copy_path)
        unset_modified
      end

      def save_if_modified
        modified? && save
      end

      def modified?       ; @modified === true  end
      def set_modified    ; @modified = true    end
      def unset_modified  ; @modified = false   end

      def path
        @path ||= projet.xfile_path
      end

      def copy_path
        @copy_path ||= File.join(projet.path, '%s-backup.scrivx' % projet.affixe)
      end

    end #/XFile
  end #/Project
end #/Scrivener
