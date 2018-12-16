# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem

      # Liste des enfants sous forme d'instance Scrivener::Project::BinderItem
      def children
        @children ||= node.elements.collect('Children/BinderItem'){|c| Scrivener::Project::BinderItem.new(projet, c)}
      end

      # Crée un nouvel élément classeur dans le binder-item courant
      #
      # RETURN Le nouveau binder-item créé {Scrivener::Project::BinderItem}
      # +attrs+   Contient les attributs, donc les propriétés qui seront
      #           dans la balise.
      # +data+    Contient les balises que contiendra l'élément.
      def create_binder_item attrs = nil, data = nil
        data  ||= Hash.new
        attrs ||= Hash.new
        # On fournit toujours l'UUID ici
        attrs.merge!('UUID' => `uuidgen`.strip)
        attrs.key?(:created)    || attrs.merge!(:created   => Time.now)
        attrs.key?(:modified)   || attrs.merge!(:modified  => Time.now)
        attrs.key?(:type)       || attrs.merge!(:type      => 'Text')

        # Le nœud contenant les enfants du binder-item
        nchildren = XML.get_or_add(node, 'Children')

        # On crée le noeud
        newdoc = nchildren.add_element('BinderItem', attrs.symbol_to_camel)

        # Le titre du document ou du dossier (if any)
        data.key?(:title) && begin
          newdoc.add_element('Title').text = data[:title].to_s.strip
        end

        # Les métadonnées
        data.key?(:metadata) || data.merge!(metadata: Hash.new)
        data[:metadata].key?(:include_in_compile) || data[:metadata].merge!(include_in_compile: {text: 'Yes'})
        metadata = newdoc.add_element('MetaData')
        data[:metadata].each do |key, mdata|
          text = mdata[:text] || mdata[:value]
          # el = metadata.add_element('IncludeInCompile')
          el = metadata.add_element(key.camelize)
          el.text = text unless text.nil?
        end

        # Les données du texte
        data.key?(:text_settings) || data.merge!(text_settings: Hash.new)
        data[:text_settings].key?(:text_selection) || data[:text_settings].merge!(text_selection: {text: '0,0'})
        textsettings = newdoc.add_element('TextSettings')
        data[:text_settings].each do |key, setting|
          text = setting.delete(:text) || setting.delete(:value) || nil
          # textsettings.add_element('TextSelection').text = text
          el = textsettings.add_element(key.camelize)
          el.text = text unless text.nil?
          setting.each do |k, v|
            el.attributes[k.camelize] = v
          end
        end

        bitem_newdoc = Scrivener::Project::BinderItem.new(projet, newdoc)

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

    end #/BinderItem
  end #/Project
end #/Scrivener
