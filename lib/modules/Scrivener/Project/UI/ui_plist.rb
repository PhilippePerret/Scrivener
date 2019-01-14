# encoding: UTF-8
class Scrivener
class Project
  # Raccourci
  def ui_plist ; ui.ui_plist end

  class UI

    # Pour gérer le fichier ui.plist
    #
    # Utiliser : project.ui.ui_plist...
    # Par exemple :
    #   puts project.ui.ui_plist['maClé']
    #   project.ui.ui_plist['maClé'] = 'nouvelle valeur' # n'enregistre pas
    #   project.ui.ui_plist.set('maClé', 'nouvelle valeur') # enregistre
    #   project.ui.ui_plist.save
    #
    def ui_plist
      @ui_plist ||= UIPlist.new(self.projet)
    end

    # Class UIPlist pour la gestion facile du fichier ui.plist
    class UIPlist

      attr_accessor :projet

      def initialize iprojet
        self.projet = iprojet
      end

      # Pour compatibilité
      def [] key
        self.xml[key]
      end
      def []= key, value
        self.xml[key] = value
        set_modified
      end
      alias :set :[]=

      # # Définit la valeur
      # def set
      #   self.xml[key] = value
      #   @modified = true
      # end

      def xml
        @xml ||= Plist.parse_xml(path)
      end
      def modified?
        @modified === true
      end
      def set_modified
        @modified = true
      end
      def save
        write_in_file(Plist::Emit.dump(xml), path)
        @modified = false
      end
      def path
        @path ||= projet.ui_plist_path
      end
    end #/UIPlist

  end #/UI
end #/Project
end #/Scrivener
