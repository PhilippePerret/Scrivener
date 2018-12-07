# encoding: UTF-8
module EditorsModule

  class Editor

    attr_accessor :ui_common
    def initialize ui_common
      self.ui_common = ui_common
    end
    # raccourci
    def set_modified; ui_common.set_modified end
    # Le nœud dans le fichier ui-common.xml
    def node
      @node ||= ui_common.xpath(xpath_str)
    end
    def view_node
      @view_node ||= node.elements['View']
    end
    # Retourne true si l'entête est visible
    def header?
      view_node.elements['ShowHeader'].text == 'Yes'
    end
    def header_visible visible = true
      view_node.elements['ShowHeader'].text = visible ? 'Yes' : 'No'
      set_modified
    end
    # Retourne true si l'entête est visible
    def footer?
      view_node.elements['ShowFooter'].text == 'Yes'
    end
    def footer_visible visible = true
      view_node.elements['ShowFooter'].text = visible ? 'Yes' : 'No'
      set_modified
    end
    # +value+ peut être : 'Single'/'Scrivenings', 'Corkboard', 'Outliner'
    def current_view_mode= value
      puts "View mode : #{value.inspect}"
      view_node.elements['CurrentViewMode'].text = value
      set_modified
    end
    def current_view_mode
      view_node.elements['CurrentViewMode'].text
    end
    # Mode de vue de groupe. C'est comme le 'current_view_mode' mais ça
    # affecte l'affichage quand un dossier ou un groupe de fichiers est
    # affiché.
    # +value+ peut être : 'Single'/'Scrivenings', 'Corkboard', 'Outliner'
    # Noter que le current_view_mode doit être synchronisé avec ce
    # groupe view mode (mais pas l'inverse)
    def group_view_mode= value
      current_view_mode = value
      view_node.elements['GroupsViewMode'].text = value
      set_modified
    end
    def group_view_mode
      view_node.elements['GroupsViewMode'].text
    end


  end #/Editor

end #/module
