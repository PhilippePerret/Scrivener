# encoding: UTF-8
=begin

  Class Project::MetaData
  -----------------------
  Gestion de la métadonnée

=end
module BuildMetadatasModule
class MetaData

  CUSTOM_METADATA_PER_TYPE = {
    text:     {'Type' => 'Text', 'Wraps' => 'No', 'Align' => 'Left'},
    checkbox: {'Type' => 'Checkbox', 'Default' => 'Yes'},
    list:     {'Type' => 'List'},
    date:     {'Type' => 'Date', 'DateType' => "Short"}
  }

  DATE_TYPES = {
    'short'       => {real: 'Short'       , key: 'short'},
    'short+time'  => {real: 'Short+Time'  , key: 'short+time'},
    'medium'      => {real: 'Medium'      , key: 'medium'},
    'medium+time' => {real: 'Medium+Time' , key: 'medium+time'},
    'long'        => {real: 'Long'        , key: 'long'},
    'long+time'   => {real: 'Long+Time'   , key: 'long+time'},
    'full'        => {real: 'Full'        , key: 'full'},
    'full+time'   => {real: 'Full+Time'   , key: 'full+time'},
    'timeOnly'    => {real: 'TimeOnly'    , key: 'timeOnly'},
    'custom'      => {real: 'Custom'      , key: 'custom'}
  }

  attr_accessor :projet
  attr_accessor :key, :data

  # Le noeud qui sera produit dans le fichier xfile
  attr_accessor :metadata_node
  # Les valeurs supplémentaires attendues en fonction du type de la métadonnée
  attr_accessor :supplement_values

  # +projet+  Instance Scrivener::Project
  # +key+     La clé de la métadonnée, ne sert pas vraiment
  # +data+    Les données de la métadonnée (en fonction de son type)
  def initialize projet, key, data
    self.projet = projet
    self.key    = key
    self.data   = data
  end
  # = main =
  #
  # Méthode de création de la métadonnée
  def create
    # debug "--> create (data = #{data.inspect})"
    conform_data
    valid?      || rt('notices.interrupted_procedure')
    not_exist?  || raise('Interrupted due to an implementation required')
    # = On procède vraiment à la création =
    get_supp_values_by_type
    create_custom_metadata_main_field
    build_or_update_supplied_elements

    projet.xfile.set_modified # pour pouvoir l'enregistrer

  end
  # retourne true si la donnée est valide
  def valid?
    type_is_valid_or_raise
    name_is_defined_or_raise
    return true
  end
  # Retourne true si la donnée existe déjà
  def not_exist?
    true
    # TODO Vérifier si la donnée existe et l'updater au besoin si
    # l'option --update est activée
  end

  def type
    @type ||= data['Type'].downcase.to_sym
  end

  def id
    @key_min ||= key.to_s.downcase.gsub(/[^[[:alnum:]]]/,'') # Même les accents
  end
  alias :key_min :id

  def title
    @title ||= data['Title']
  end

  # Créer le noeud dans le fichier xfile
  def create_custom_metadata_main_field
    md_field = XML.get_or_add(projet.xfile.root, 'CustomMetaDataSettings/MetaDataField[@ID="%s"]' % key_min)
    md_field.attributes['ID'] = key_min
    # debug "\n-- data avant mise des attributs : #{data.inspect}"
    CUSTOM_METADATA_PER_TYPE[type].each do |attr, valdefaut|
      md_field.attributes[attr] = data[attr] || valdefaut
    end
    md_title = XML.get_or_add(md_field, 'Title')
    md_title.text = title
    self.metadata_node = md_field
  end
  # /create_custom_metadata_main_field
  private :create_custom_metadata_main_field

  # Construction des éléments supplémentaires en fonction du type
  def build_or_update_supplied_elements
    case type
    when :list
      # Liste des options définies dans :options
      # de hdata (cf. ci-dessus)
      md_list = XML.get_or_add(metadata_node, 'ListOptions')
      first_option = nil
      if supplement_values['Options'].is_a?(Array)
        supplement_values['Options'].each.with_index do |tit, idx|
          n_option = XML.get_or_add(md_list, ('Option[@ID="%i"]' % idx))
          n_option.text = tit
          first_option || first_option = tit
        end
      else # options Hash fournies avec ID
        supplement_values['Options'].each.with_index do |oid, tit|
          n_option = XML.get_or_add(md_list, ('Option[@ID="%s"]' % oid.to_s))
          n_option.text = tit
          first_option || first_option = tit
        end
      end
      # On met la valeur par défaut
      md_list.attributes['None'] = supplement_values['Default'] || first_option
    when :date
      # debug "--> when :date (supplement_values: #{supplement_values.inspect})"
      if supplement_values['DateFormat']
        md_format = XML.get_or_add(metadata_node, 'DateFormat')
        md_format.text = supplement_values['DateFormat']
      end
    end

  end
  # /build_or_update_supplied_elements
  private :build_or_update_supplied_elements

  # Pour ajouter les valeurs supplémentaires en fonction du type de
  # la métadonnée
  def get_supp_values_by_type
    CLI.debug_entry
    sup_values = Hash.new
    case type
    when :text
      # Ne rien faire
    when :list
      sup_values = {
        'Options' => data.delete('Options') || rt('metadatas.errors.list_items_required', nil, ArgumentError),
        'Default' => data.delete('Default') || 'None'
      }
    when :date
      if data.key?('Format')
        fmt = data['Format'].downcase
        if DATE_TYPES.key?(fmt) && fmt != 'custom'
          data.merge!('DateType' => DATE_TYPES[fmt][:real])
        else
          data.merge!('DateType' => 'Custom')
          sup_values.merge!('DateFormat' => data.delete('Format'))
        end
      elsif data.key?('DateFormat')
        sup_values.merge!('DateFormat' => data['DateFormat'])
      end
    end
    # debug "---- data après définition supp-value: #{data.inspect}"
    # debug "---- supplement_values après définition supp-value: #{sup_values.inspect}"
    self.supplement_values = sup_values
  rescue Exception => e
    CLI.debug(e)
    raise_by_mode(e, Scrivener.mode)
  ensure
    CLI.debug_exit
  end
  # /get_supp_values_by_type
  private :get_supp_values_by_type

  # Les clés de +data+ qu'il ne faut pas transformer
  NO_KEY_TRANSFORM = ['Title', 'Type', 'DateType', 'DateFormat']
  # Les valeurs de +data+ qu'il ne faut pas transformer
  NO_VAL_TRANSFORM = ['Title', 'DateType', 'DateFormat', 'Format']

  # Méthode qui prend les données transmises (par le fichier YAML ou la
  # ligne de commande) et en fait des données conforme. Par exemple, si
  # le type doit toujours être capitalisé
  def conform_data
    CLI.debug_entry
    newh = Hash.new

    # debug "--- data initiale: #{data.inspect}"

    # Dans un premier temps, on passe toutes les clés en majuscule
    data.each do |k, v|
      k = NO_KEY_TRANSFORM.include?(k) ? k.to_s : k.to_s.capitalize
      newh.merge!(k => v)
    end

    # # On doit conserver certaines valeurs telles quelles
    # if newh.key?('Format') # de date par exemple
    #   self.data_format_init = newh['Format']
    # end

    # On réduit certaines clés
    newh['Title'] || begin
      ['Titre', 'Name', 'Nom'].each do |prop|
        newh[prop] || next
        newh.merge!('Title' => newh.delete(prop)) and break
      end
    end
    newh['Default'] || begin
      ['Defaut', 'Défaut', 'Checked'].each do |prop|
        newh.key?(prop) || newh.key?(prop.downcase) || next
        val = newh.key?(prop) ? newh.delete(prop) : newh.delete(prop.downcase)
        val.capitalize if val.is_a?(String)
        newh.merge!('Default' => val) and break
      end
    end
    if newh['Default'] === false
      newh['Default'] = 'No'
    elsif newh['Default'] === true
      newh['Default'] = 'Yes'
    end

    # Ensuite on peut capitaliser toutes les valeurs (sauf Title)
    data = Hash.new
    newh.each do |k,v|
      v.is_a?(String) && !NO_VAL_TRANSFORM.include?(k) && v = v.capitalize
      data.merge!(k => v)
    end
    # debug "-- data conformisées : #{data.inspect}"
    self.data = data
  rescue Exception => e
    CLI.debug(e)
    raise_by_mode(e, Scrivener.mode)
  else
    CLI.debug_exit
  end
  # /conform_data

  # ---------------------------------------------------------------------
  #   Méthodes fonctionnelles

  def type_is_valid_or_raise
    CUSTOM_METADATA_PER_TYPE.key?(type) || rt('values.errors.type_invalid', {type: type}, ArgumentError)
  end
  def name_is_defined_or_raise
    title != nil || rt('metadata.errors.title_undefined', {id: key})
  end
end #/class MetaData
end #/module
