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

    # Pour définir le contenu de l'éditeur
    #
    # L'éditeur peut contenir un seul document, ou plusieurs (en mode groupe)
    def content= bitems
      bitems.is_a?(Array) || bitems = [bitems]
      bitems.first.is_a?(Scrivener::Project::BinderItem) || raise(Scrivener::ERRORS[:binder_item_required])
      if main?
        ui_common.binder.unselect_all
        bitems.each { |bitem| ui_common.binder.select(bitem, keep = true) }
      end
      content_node = XML.get_or_add(view_node, 'Content')
      XML.empty(content_node)
      # On ajoute chaque binder-item
      bitems.each do |bitem|
        content_node.add_element('ItemID').text = bitem.uuid
      end
      set_modified
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
      self.current_view_mode = value
      view_node.elements['GroupsViewMode'].text = value
      set_modified
    end
    def group_view_mode
      view_node.elements['GroupsViewMode'].text
    end


  end #/Editor

end #/module
