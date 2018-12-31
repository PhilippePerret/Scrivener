# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem

      # Liste des enfants sous forme d'instance Scrivener::Project::BinderItem
      def children
        @children ||= node.elements.collect('Children/BinderItem'){|c| Scrivener::Project::BinderItem.new(projet, c)}
      end

      # Tous les descendants
      def descendants
        @descendants ||= begin
          des = Array.new
          if parent?
            des += children
            children.each { |child| des += child.descendants }
          end
          des
        end
      end

      # Crée un nouvel élément classeur dans le binder-item courant
      #
      # RETURN Le nouveau binder-item créé {Scrivener::Project::BinderItem}
      # +attrs+   Contient les attributs, donc les propriétés qui seront
      #           dans la balise.
      # +data+    Contient les balises que contiendra l'élément.
      def create_binder_item attrs = nil, data = nil
        # puts "--> create_binder_item(#{attrs.inspect}, #{data.inspect})"
        attrs, data = create_default_values(attrs, data)
        # Le nœud contenant les enfants de ce binder-item
        newdoc = create_child_node_with_titre(data[:title], attrs)
        # On récupère la cible avant d'écrire les données méta
        if data[:text_settings]
          dtarget = data[:text_settings].delete(:target)
        end
        # On inscrit les données méta (il y en a toujours au moins une,
        # par défaut)
        add_metadata_in_new_child_node(newdoc, data)
        # Le binder-item enfant
        bitem_newdoc = Scrivener::Project::BinderItem.new(projet, newdoc)

        dtarget && bitem_newdoc.target.define(dtarget)
          # {value: final_value, type: 'Characters', notify: false, show_overrun: true, show_buffer: true}

        data[:custom_metadatas].each do |key, mdata|
          # Il faut définir la métadonnée customisée de façon générale
          # dans <CustomMetaDataSettings>. C'est fait au niveau du
          # projet, pas au niveau de ce binder-item
          # Il faut ensuite définir la métadonnée pour le binder-item
          # en particulier
          bitem_newdoc.custom_metadatas[key.to_s.downcase]= mdata[:value]
        end


        # On indique que le fichier xfile a été modifié pour
        # qu'il soit sauvé
        projet.xfile.set_modified


        # Pour finir, il faut créer le dossier dans Data/Files, portant comme nom
        # le UUID du fichier
        # Et y mettre le texte s'il est défini dans les données
        bitem_newdoc.build_data_file_folder
        data[:content] && bitem_newdoc.set_content(data[:content])


        return bitem_newdoc
      end
      #/create_binder_item


      # ---------------------------------------------------------------------

      def create_default_values attrs, data
        data  ||= Hash.new
        attrs ||= Hash.new
        # On fournit toujours l'UUID ici
        attrs.merge!('UUID' => `uuidgen`.strip)
        attrs.key?(:created)    || attrs.merge!(:created   => Time.now)
        attrs.key?(:modified)   || attrs.merge!(:modified  => Time.now)
        attrs.key?(:type)       || attrs.merge!(:type      => 'Text')
        return [attrs, data]
      end
      # /create_default_values
      private :create_default_values

      # Création de l'enfant : création du nœud XML, avec son titre
      def create_child_node_with_titre title = nil, attrs
        nchildren = XML.get_or_add(node, 'Children')
        newdoc = nchildren.add_element('BinderItem', attrs.symbol_to_camel)
        # Le titre du document ou du dossier (if any)
        title && newdoc.add_element('Title').text = title.to_s.strip
        return newdoc
      end
      # /create_child_node_with_titre
      private :create_child_node_with_titre

      # Ajoute les données méta au noeud XML du nouveau child +newdoc+
      DEFAULT_METADATA = {
        include_in_compile: {text: 'Yes'}
      }
      def add_metadata_in_new_child_node newdoc, data
        # Les métadonnées
        dmetadata = DEFAULT_METADATA.merge(data[:metadata]||{})
        metadata = newdoc.add_element('MetaData')
        dmetadata.each do |key, mdata|
          text = mdata[:text] || mdata[:value]
          el = metadata.add_element(key.camelize)
          el.text = text unless text.nil?
        end
      end
      private :add_metadata_in_new_child_node

      # Ajoute les données de texte au nouveau nœud XML du nouveau child +newdoc+
      DEFAULT_TEXT_SETTINGS = {
        text_selection: {text: '0,0'}
      }
      def add_text_settings_in_new_child_node newdoc, data
        # Les données du texte
        dsettings = DEFAULT_TEXT_SETTINGS.merge(data[:text_settings]||{})
        textsettings = newdoc.add_element('TextSettings')
        dsettings.each do |key, setting|
          text = setting.delete(:text) || setting.delete(:value) || nil
          el = textsettings.add_element(key.camelize)
          el.text = text unless text.nil?
          setting.each do |k, v|
            el.attributes[k.camelize] = v
          end
        end
      end
      private :add_text_settings_in_new_child_node

    end #/BinderItem
  end #/Project
end #/Scrivener
