# encoding: UTF-8
=begin

  Méthodes utiles

    project.binder_item(<uuid>) retourne l'instance Scrivener::Project::BinderItem
    de n'importe quel binder du dossier manuscrit.

    project.binder_items
      retourne la liste des binder-items {Scrivener::Project::BinderItem} mais
      seulement de premier niveau (pas les sous-éléments, qu'il faudra traiter
      à l'aide de la méthode `parent?` et `children`).

=end
class Scrivener
  class Project

    # Retourne l'instance {Scrivener::Project::BinderItem} du binder item du
    # projet portant l'UUID +uuid+
    #
    # Note : cette méthode (contrairement aux suivante) considère vraiment
    # TOUS les binder-items, à commencer par le dossier manuscrit principal
    # (alors que `binder_items` ci-dessous ne recherche que les éléments du
    # dossier manuscrit, même pas le dossier manuscrit lui-même)
    def binder_item uuid
      @hash_binder_items ||= begin
        h = Hash.new
        xfile.binder.elements.each('BinderItem') do |data_node|
          bi = Scrivener::Project::BinderItem.new(self, data_node)
          bi.merge_in(h)
        end
        h
      end
      @hash_binder_items[uuid]
    end

    # Retourne tous les binder-items du projet (ceux du manuscrit)
    # C'est une liste d'instances de {Scrivener::Project::BinderItem}
    #
    # ATTENTION : POUR LE MOMENT, ça ne retourne que la liste des binder-items
    # de premier niveau, pas leur sous-élément.
    # CONTRAIREMENT à la méthode binder_item ci-dessous qui elle contient tous
    # les binder-items, même ceux imbriqués
    #
    # Pour les obtenir tous, il faut boucler sur leur children et les children
    # de leur children
    def binder_items
      @binder_items ||= begin
        xfile.draftfolder.elements.collect('Children/BinderItem') do |data_node|
          Scrivener::Project::BinderItem.new(self, data_node)
        end
      end
    end

    # +options+
    #   :only_text    Seulement les textes
    def all_binder_items_of dossier, options = nil
      options ||= Hash.new
      arr = Array.new
      dossier.elements.each('Children/BinderItem') do |data_node|
        bitem = Scrivener::Project::BinderItem.new(self, data_node)
        add_binder_item_in(arr, bitem, options)
      end
      return arr
    end
    def add_binder_item_in arr, bitem, options
      unless options[:only_text] && !bitem.text?
        arr << bitem
      end
      bitem.children || return
      bitem.children.each do |child|
        add_binder_item_in arr, child, options
      end
      return arr
    end

    # Pour composer la tablea @hash_binder_items du projet qui contient en
    # clé l'UUID du fichier et en valeur l'instance Scrivener::Project::BinderItem
    class BinderItem
      def merge_in h
        h.merge!(self.uuid => self)
        self.parent? && self.children.each{|bic| bic.merge_in(h)}
      end
    end #/BinderItem


    # Méthode principale qui crée un nouveau document pour le
    # projet. Avec éventuellement les données +data+
    #
    # @return Le nouveau document créé {Scrivener::Project::BinderItem}
    def create_binder_item attrs = nil, data = nil
      data  ||= Hash.new
      attrs ||= Hash.new
      # On fournit toujours l'UUID ici
      attrs.merge!('UUID' => `uuidgen`.strip)
      attrs.key?(:created)    || attrs.merge!(:created   => Time.now)
      attrs.key?(:modified)   || attrs.merge!(:modified  => Time.now)
      attrs.key?(:type)       || attrs.merge!(:type      => 'Text')

      # On doit définir le conteneur
      conteneur =
        case data[:container]
        when String
          container = data.delete(:container)
          # xfile.draftfolder.elements["*/BinderItem[@UUID=\"#{container}\"]"]
          xfile.node.elements["*/BinderItem[@UUID=\"#{container}\"]"]
        when Scrivener::Project::BinderItem
          raise 'Je ne sais pas traiter les BinderItem'
        else
          # Sinon, on prend le dossier manuscrit
          xfile.draftfolder
        end

      docs = conteneur.elements['Children'] || conteneur.add_element('Children')

      newdoc = docs.add_element('BinderItem', attrs.symbol_to_camel)

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
        setting.each do |key, value|
          el.attributes[key.camelize] = value
        end
      end

      bitem_newdoc = Scrivener::Project::BinderItem.new(self, newdoc)

      # Pour finir, il faut créer le dossier dans Data/Files, portant comme nom
      # le UUID du fichier
      bitem_newdoc.build_data_file_folder

      return bitem_newdoc
    end
    #/create_binder_item

  end #/Project
end #/Scrivener
