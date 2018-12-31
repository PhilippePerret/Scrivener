# encoding: UTF-8
class Scrivener
class Project

  # Path du fichier du projet (qui sert à son instanciation)
  attr_reader :path

  # l'UUID du dossier courant dans lequel doit être placé
  # le document courant, ou nil
  # # TODO Il faudrait se passer de cette propriété, maintenant
  # # qu'on sait créer un binder-item n'importe où.
  # attr_accessor :current_folder

  def title
    @title || get_long_title
  end

  def title_abbreviated
    @title_abbreviated ||= get_abbreviate_title
  end

  def authors
    @authors ||= get_authors
  end

  # Date de dernière modification du projet
  def modified_at
    @modified_at ||= File.stat(path).mtime
  end

  # Pour définir une méta-donnée personnalisé
  #      <CustomMetaDataSettings>
  #       <MetaDataField ID="id" Type="Text" Wraps="No" Align="Center">
  #         <Title>ID</Title>
  #       </MetaDataField>
  #       <MetaDataField ID="autredonnéecustomisée" Type="Checkbox" Default="Yes">
  #         <Title>Autre donnée customisée</Title>
  #       </MetaDataField>
  #       </CustomMetaDataSettings>
  # Attention : le projet (xfile) doit être enregistré après cette
  # opération.
  CUSTOM_METADATA_PER_TYPE = {
    text:     {'Type' => 'Text', 'Wraps' => 'No', 'Align' => 'Left'},
    checkbox: {'Type' => 'Checkbox', 'Default' => 'Yes'}
  }
  def define_custom_metadata_if_needed(hdata)
    hdata.each do |key, mdata|
      cmdata_id = key.to_s.downcase
      mdata_field = XML.get_or_add(xfile.root, 'CustomMetaDataSettings/MetaDataField[@ID="%s"]' % cmdata_id)
      CUSTOM_METADATA_PER_TYPE[mdata[:type]].each do |attr, valdefaut|
        mdata_field.attributes[attr] = mdata[attr] || valdefaut
      end
      mdata_title = XML.get_or_add(mdata_field, 'Title')
      mdata_title.text = mdata[:title]
    end
  end
  # /define_custom_metadata_if_needed

end #/Project
end #/Scrivener
