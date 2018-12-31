# encoding: UTF-8
module XMLModule

  class XML

    class << self
      # Retourne l'enfant +tag+ de +parent+ en le créant si nécessaire
      # Note : depuis déc 2018, peut créer un path complet 'path/to/node'
      def get_or_add(parent, tag)
        tag.split('/').each do |node_name|
          parent =
            if parent.elements[node_name]
              parent.elements[node_name]
            else
              add_node(parent, get_tagname_and_attributes_from(node_name))
            end
        end
        return parent
      end

      # Ajoute le noeud défini par +data_node+ dans +parent+ et
      # retourne le noeud créé
      def add_node(parent, data_node)
        neu = parent.add_element(data_node[:tagname], data_node[:attributes])
        data_node[:text] && neu.text = data_node[:text]
        return neu
      end

      # Retourne l'enfant +tag+ de +parent+ sans le créer
      # Note : depuis déc 2018, peut créer un path complet 'path/to/node'
      def get(parent, tag)
        tag.split('/').each do |node_name|
          parent = parent.elements[node_name]
          parent || return
        end
        return parent
      end
      # Pour vider le nœud +node+ de tout son contenu (mais en gardant
      # la balise)
      def empty(node)
        node.elements.each { |n| n.parent.delete(n) }
      end
      # ---------------------------------------------------------------------
      #   Méthodes fonctionnelles

      # Reçoit un String de la forme 'TagName' ou 'TagName[@attr="valeur"]'
      # ou même 'TagName[@attr="valeurAttr"][text()="Valeur Texte"]'
      # et retourne une table contenant :
      #   {:tagname, :attributes et :text}
      def get_tagname_and_attributes_from(str)
        index_crochet = str.index(/\[/)
          attrs = Hash.new
          texte = nil
        if index_crochet
          tag = str[0...index_crochet]
          str.scan(/(?:\[(.*?)=(.*?)\])/).each do |found|
            attr = found.first
            valu = found.last.gsub(/^"?(.*?)"?$/,'\1')
            if attr == 'text()'
              texte = valu
            else
              attrs.merge!(attr[1..-1] => valu)
            end
          end
        else
          tag = str
        end
        return {tagname: tag, attributes: attrs, text: texte}
      end

    end #/<< self


    attr_accessor :projet
    attr_accessor :path

    # Instanciation
    #
    # +path+    {String} Chemin d'accès au fichier XML
    # +iprojet+ {Scrivener::Project} Projet Scrivener du fichier
    def initialize iprojet, path
      self.projet = iprojet
      self.path   = path
    end

    # Le document XML
    def docxml
      @docxml ||= REXML::Document.new(File.new(path))
    end

    # Racine du fichier
    def root ; @root ||= docxml.root end

    def modified?
      @modified === true
    end
    def set_modified
      @modified = true
    end

    # Retourne le nœud spécifié par le xpath +xp+
    def xpath xp
      REXML::XPath.first(docxml, xp)
    end

    # Détruit tous les éléments du +xpath+ fourni
    def delete_all_of_xpath xpath
      count = REXML::XPath.first(docxml, xpath).elements.count
      count.times do
        REXML::XPath.first(docxml, xpath).elements.delete(1)
      end
      @modified = true
    end
    alias :remove_children_of_xpath :delete_all_of_xpath

    # Pour définir un élément, par l'xpath
    def set_xpath xpath, value
      REXML::XPath.first(docxml, xpath).text = value
      @modified = true
    end

    # Pour ajouter un noeud au xpath +xpath+ avec les données +node_data+ qui
    # doivent contenir :
    #   :tag      Nom du nœud (balise)
    #   :text     Le texte, s'il contient du texte
    #   :attrs    Les attributs de la balise, si elle est en contient
    def add_xpath xpath, node_data
      tag = node_data.delete(:tag)
      txt = node_data.delete(:text)
      att = node_data.delete(:attrs) || Hash.new
      attrs = Hash.new
      att.each{|p,v| attrs.merge!(p.to_s => v)}
      new_node = REXML::XPath.first(docxml, xpath).add_element(tag, attrs)
      txt && new_node.text = txt
      @modified = true
    end

    # Pour sauver le document
    def save
      docfile = File.new(path,'wb')
      docxml.write(output: docfile)
      @modified = false
    end

    # Les métadonnées, if any
    def metadata
      @metadata ||= begin
        # n = root.elements['CompileSettings']elements['Metadata'].first
        REXML::XPath.first(docxml, '//MetaData')
      end
    end

    # Les options, if any
    def options
      @options ||= REXML::XPath.first(docxml, '//Options')
    end
  end

end
