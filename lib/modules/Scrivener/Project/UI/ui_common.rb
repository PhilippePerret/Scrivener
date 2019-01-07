# encoding: UTF-8
=begin

  Module qui gère le fichier ui-common.xml qui contient les données
  générales de l'interface, comme l'historique, les dossier ouverts dans le
  classeur ou autres visibilité de l'inspecteur, etc.

=end
require_relative 'lib/editors_module'
include XMLModule

class Scrivener
class Project

  # Raccourci
  def ui_common
    ui.ui_common
  end

  class UI
    # include XMLModule

    def ui_common
      @ui_common ||= UICommon.new(self.projet.ui_common_path, self.projet)
    end

    # @usage:  project.ui.split_editor
    #
    # Noter qu'il faut que le contenu de l'éditeur secondaire (editor2) soit
    # défini pour que cette valeur soit prise en compte.
    def split_editor sens = 'Horizontal'
      ui_common.xpath('/UIStates/Split').text = sens
    end
    def unsplit_editor
      split_editor('None')
    end

    # Class UIPlist pour la gestion facile du fichier ui.plist
    class UICommon < XML

      include EditorsModule

      def initialize path, iprojet
        self.path   = path
        self.projet = iprojet
      end

      # Le classeur
      def binder
        @binder ||= Binder.new(self)
      end

      # Le premier éditeur
      def editor1
        @editor1 ||= Editor1.new(self) # dans UI/lib/editors_module.rb
      end

      # Le second éditeur
      def editor2
        @editor2 ||= Editor2.new(self) # dans UI/lib/editors_module.rb
      end

      # L'inspecteur
      def inspector
        @inspector ||= Inspector.new(self)
      end

      # ---------------------------------------------------------------------
      #   CLASSEUR

      class Binder
        attr_accessor :ui_common
        def initialize uicommon
          self.ui_common = uicommon
        end
        def set_modified ; ui_common.set_modified end # raccourci
        def node
          @node ||= ui_common.xpath('/UIStates/Binder')
        end
        def visible?
          node.attributes['Show'] == 'Yes'
        end
        def visibility visible
          node.attributes['Show'] = visible ? 'Yes' : 'No'
          set_modified
        end
        # Ajoute un dossier ouvert
        def close_folder bitem
          bitem.is_a?(Scrivener::Project::BinderItem) || raise(ERRORS[:binder_item_required])
          node.elements['ExpandedItems'] || return
          if n.text == bitem.uuid
            n.parent.delete(n)
            unselect(bitem) # s'il est sélectionné
            set_modified
          end
        end
        # Fermer tous les dossiers
        def close_all_folder
          node.elements['ExpandedItems'] || return
          node.elements.delete_all('ExpandedItems')
        end
        # Retire un dossier ouvert (donc le referme)
        def open_folder bitem
          bitem.is_a?(Scrivener::Project::BinderItem) || raise(ERRORS[:binder_item_required])
          XML.get_or_add(node, 'ExpandedItems').
            add_element('ItemID').text = bitem.uuid
          set_modified
        end
        # Pour sélectionner un item
        # Si +keep+ est true, on garde la sélection courante pour faire une
        # sélection multiple.
        def select bitem, keep = false
          bitem.is_a?(Scrivener::Project::BinderItem) || raise(ERRORS[:binder_item_required])
          keep || unselect_all
          XML.get_or_add(node,'Selection').add_element('ItemID').text=bitem.uuid
          set_modified
        end
        # Pour désélectionner un item (s'il l'était)
        # Noter que si l'élément n'était pas sélectionné, rien n'est produit,
        # pas d'erreur
        def unselect bitem
          bitem.is_a?(Scrivener::Project::BinderItem) || raise(ERRORS[:binder_item_required])
          node.elements['Selection']        || return
          node.elements['Selection/ItemID'] || return
          ui_common.xpath('/UIStates/Binder/Selection').elements.each('ItemID') do |n|
            n.text == bitem.uuid || next
            n.parent.delete(n)
            set_modified and break
          end
        end
        # Pour tout déselectionner (même le premier)
        def unselect_all
          node.elements['Selection']        || return
          node.elements['Selection/ItemID'] || return
          node.elements.delete('Selection')
          set_modified
        end
      end #/ class Binder (le classeur)

      # ---------------------------------------------------------------------
      #   COLLECTIONS
      def collections_visible?
        xpath('/UIStates/Binder/ShowCollections').text == 'Yes'
      end
      def collections_visibility visible
        xpath('/UIStates/Binder/ShowCollections').text = visible ? 'Yes' : 'No'
        set_modified
      end

      # ---------------------------------------------------------------------
      #   LES DEUX ÉDITEURS
      class Editor1 < Editor
        def xpath_str ; @xpath_str ||= '/UIStates/Editors/Editor1' end
        def main? ; true end
      end #/Editor1

      class Editor2 < Editor
        def xpath_str ; @xpath_str ||= '/UIStates/Editors/Editor2' end
        def main? ; false end
      end #/Editor2

      # ---------------------------------------------------------------------
      #   INSPECTEUR
      class Inspector
        attr_accessor :ui_common
        def initialize uicommon
          self.ui_common = uicommon
        end
        def set_modified ; ui_common.set_modified end

        def visible?
          ui_common.xpath('/UIStates/Inspector').attributes['Show'] == 'Yes'
        end
        def visibility visible
          ui_common.xpath('/UIStates/Inspector').attributes['Show'] = visible ? 'Yes' : 'No'
          set_modified
        end
        def set_onglet onglet # parmi 'Bookmarks'
          ui_common.xpath('/UIStates/Inspector').attributes['View'] = onglet
          set_modified
        end
      end #/ Inspector

    end #/UICommon
  end #/UI
end #/Project
end #/Scrivener
