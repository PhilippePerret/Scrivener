# encoding: UTF-8
=begin

  Lorsqu'on utilise scriv build metadata

  Définition de la métadata
  <ScrivenerProject ...>
    <CustomMetaDataSettings>
          # Une métadata textuelle
          <MetaDataField ID="id" Type="Text" Wraps="No" Align="Left">
              <Title>ID</Title>
          </MetaDataField>
          # Une liste
          <MetaDataField ID="prior" Type="List">
              <Title>Prior</Title>
              <ListOptions None="Aucune">
                  <Option ID="0">Mini</Option>
                  <Option ID="1">Forte</Option>
                  <Option ID="2">Urgent</Option>
              </ListOptions>
          </MetaDataField>
      </CustomMetaDataSettings>

      <MetaDataField ID="donnéedate" Type="Date" DateType="Medium+Time">
          <Title>Donnée date</Title>
          <DateFormat></DateFormat>
      </MetaDataField>


TODO Pouvoir partir d'un fichier YAML pour tout définir
-
 type: ...
 ID:   ...


=end
module BuildMetadataModule

  CUSTOM_METADATA_PER_TYPE = {
    text:     {'Type' => 'Text', 'Wraps' => 'No', 'Align' => 'Left'},
    checkbox: {'Type' => 'Checkbox', 'Default' => 'Yes'},
    list:     {'Type' => 'List'},
    date:     {'Type' => 'Date', 'DateType' => "Short"}
  }

  def get_or_create_custom_metadatas(hdata)
    hdata.each do |key, mdata|
      sup_values = get_supp_values_by_type(mdata)
      mdata_field = create_custom_metadata_main_field(mdata, key)
      build_or_update_supplied_elements(mdata_field, mdata, sup_values)
    end
  end
  # /get_or_create_custom_metadatas

  def create_custom_metadata_main_field(mdata, key)
    cmdata_id = key.to_s.downcase # Même les accents
    mdata_field = XML.get_or_add(xfile.root, 'CustomMetaDataSettings/MetaDataField[@ID="%s"]' % cmdata_id)
    mdata_field.attributes['ID'] = cmdata_id
    CUSTOM_METADATA_PER_TYPE[mdata[:type]].each do |attr, valdefaut|
      mdata_field.attributes[attr] = mdata[attr] || valdefaut
    end
    mdata_title = XML.get_or_add(mdata_field, 'Title')
    mdata_title.text = mdata[:title]
    return mdata_field
  end
  # /create_custom_metadata_main_field
  private :create_custom_metadata_main_field

  def get_supp_values_by_type(mdata)
    sup_values = Hash.new
    case mdata[:type]
    when :list
      sup_values = {
        options: mdata.delete(:options) || raise_options_required_for_cm_list,
        default: mdata.delete(:default) || 'None'
      }
    when :date
      sup_values[:date_format] = mdata.delete(:format)
    end
    return sup_values
  end
  # /get_supp_values_by_type
  private :get_supp_values_by_type

  def build_or_update_supplied_elements(mdata_field, mdata, evalues)
    # Construction des éléments supplémentaires
    case mdata[:type]
    when :list
      # Liste des options définies dans :options
      # de hdata (cf. ci-dessus)
      mdata_list = XML.get_or_add(mdata_field, 'ListOptions')
      mdata_list.attributes['None'] = evalues[:default]
      evalues[:options].each do |val, tit|
        n_option = XML.get_or_add(mdata_list, ('Option[@ID="%s"]' % val))
        n_option.text = tit
      end
    when :date
      if evalues[:date_format]
        mdata_format = XML.get_or_add(mdata_field, 'DateFormat')
        mdata_format.text = evalues[:date_format]
      end
    end
  end
  # /build_or_update_supplied_elements
  private :build_or_update_supplied_elements

  def raise_options_required_for_cm_list
    raise(ERRORS[:build][:custom_metadatas][:options_required])
  end

end #/module
