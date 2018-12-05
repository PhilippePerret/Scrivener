# encoding: UTF-8
class Scrivener
class Project
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
    end

    # Définit la valeur et l'enregistre (contrairement à `[]=`)
    def set
      self.xml[key] = value
      save
    end

    def xml
      @xml ||= Plist.parse_xml(path)
    end
    def save
      File.open(path,'wb'){|f| f.write Plist::Emit.dump(xml)}
    end
    def path
      @path ||= projet.ui_plist_path
    end
  end #/UIPlist

end #/UI
end #/Project
end #/Scrivener
