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

    # ---------------------------------------------------------------------
    #   Gestion du texte


    # Pour définir le contenu de l'éditeur (le ou les fichiers affichés)
    #
    # L'éditeur peut contenir un seul document, ou plusieurs (en mode groupe)
    #
    # NOTE Ne surtout pas l'inclure dans l'historique.
    def content= bitems
      bitems.is_a?(Array) || bitems = [bitems]
      bitems.first.is_a?(Scrivener::Project::BinderItem) || rt('binder_items.errors.binder_item_required', nil, ArgumentError)
      if main?
        ui_common.binder.unselect_all
        bitems.each { |bitem| ui_common.binder.select(bitem, true) }
      else
        # Si c'est le contenu de l'éditeur secondaire qui est défini,
        # il faut le rendre visible sinon ça ne fait rien.
        project.ui.split_editor
      end
      content_node = XML.get_or_add(view_node, 'Content')
      XML.empty(content_node)
      # On ajoute chaque binder-item
      bitems.each do |bitem|
        content_node.add_element('ItemID').text = bitem.uuid
      end
      set_modified
    end

    # Retourne la sélection texte
    def text_selection
      node.elements['Text'].elements['Selection'].text.split(',').collect{|i|i.to_i}
    end
    # Pour définir la sélection du texte
    # +paire+ [offset premier caractère, nombre de caractères]
    # TODO Traiter avec des valeurs négatives (à commencer par 0, -1)
    # La difficulté réside dans le fait de parvenir à connaitre le contenu
    # de l'éditeur.
    def text_selection= paire
      # paire = paire.collect.each do |v|
      #   if v < 0
      #     v =
      #   end
      #   v
      # end
      node.elements['Text'].elements['Selection'].text = paire.join(',')
    end

    # ---------------------------------------------------------------------
    #   Historique

    def reset_historique
      node_histo = XML.get_or_add(view_node, 'NavigationHistory')
      XML.empty(node_histo)
      node_histo.attributes['CurrentIndex'] = '-1'
    end
    # +options+
    #   :last_is_current      Si true, on met le contenu du dernier dans
    #                         le contenu.
    def add_historique bitems, options = nil
      options ||= Hash.new
      bitems.is_a?(Array) || bitems = [bitems]
      node_histo = XML.get_or_add(view_node, 'NavigationHistory')
      last_index = node_histo.attributes['CurrentIndex'].to_i
      bitems.each do |bitem|
        node_histo.add_element('HistoryItem', {'Type' => 'BinderItem', 'ViewMode' => 'Single'}).text = bitem.uuid
      end
      node_histo.attributes['CurrentIndex'] = last_index + bitems.count
      if options[:last_is_current]
        self.content= bitems.last
      end
    end

    # ---------------------------------------------------------------------
    #   Entête et pied de page

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
    alias :view_mode :current_view_mode

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
