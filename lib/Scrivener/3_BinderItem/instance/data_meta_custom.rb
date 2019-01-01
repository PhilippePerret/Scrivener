# encoding: UTF-8
class Scrivener
class Project
class BinderItem

  # Données personnalisées
  # @usage
  #   <binder>.custom_metadatas['<field id>']
  #   # => Valeur du champ field_id
  #   <binder>.custom_metadatas['<field id>']= '<field valeur>'
  #   # => Met le champ à cette valeur (le crée si nécessaire)
  def custom_metadatas
    @custom_metadatas ||= CustomMetaDatas.new(self)
  end

  class CustomMetaDatas
    attr_accessor :binder_item, :field_id, :field_value
    def initialize bitem
      self.binder_item  = bitem
    end
    # Pour obtenir la valeur d'une métadonnée personnalisée
    def [] field_id
      get_field_value(field_id)
    end
    # Pour définir la valeur d'une métadonnée personnalisée
    def []= field_id, field_value
      set_field_value(field_id, field_value)
    end
    # Pour obtenir le nœud de la métadata d'id +field_id+
    def node_of(field_id)
      node || return # aucune donnée customisée
      n = REXML::XPath.first(node, 'MetaDataItem/FieldID[text()="%s"]' % [field_id.downcase])
      n || return
      n.parent
    end
    # Le noeud des métadata du binder-item
    def node
      @node ||= REXML::XPath.first(binder_item.node, 'MetaData/CustomMetaData')
    end

    # ---------------------------------------------------------------------
    #   Private method de CustomMetaDatas

    def set_field_value(field_id, field_value)
      n = node_of(field_id)
      if n.nil?
        create_custom_metadata(field_id, field_value)
      else
        n.elements['Value'].text = field_value
      end
      binder_item.projet.xfile.set_modified
    end
    private :set_field_value

    def get_field_value(field_id)
      n = node_of(field_id) || return
      n.elements['Value'].text
    end
    private :get_field_value

    def create_custom_metadata(field_id, field_value)
      n = XML.get(binder_item.node, 'MetaData/CustomMetaData/MetaDataItem/FieldID[text()="%s"]' % field_id.downcase)
      unless n.nil?
        n = n.parent
      else
        n = XML.get_or_add(binder_item.node, 'MetaData/CustomMetaData')
        n = n.add_element('MetaDataItem')
      end
      n.add_element('FieldID').text = field_id.downcase
      n.add_element('Value').text   = field_value
    end
    private :create_custom_metadata

  end #/CustomMetaDatas

end #/BinderItem
end #/Project
end #/Scrivener
