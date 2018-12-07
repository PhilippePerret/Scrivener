# encoding: UTF-8
module XMLModule

  class XML

    class << self
      # Retourne l'enfant +tag+ de +parent+ en le créant si nécessaire
      def get_or_add(parent, tag)
        parent.elements[tag] ? parent.elements[tag] : parent.add_element(tag)
      end
      # Pour vider le nœud +node+ de tout son contenu (mais en gardant
      # la balise)
      def empty(node)
        node.elements.each { |n| n.parent.delete(n) }
      end
    end #/<< self

    attr_accessor :projet
    attr_accessor :path
    def initialize path, iprojet
      self.path   = path
      self.projet = iprojet
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
