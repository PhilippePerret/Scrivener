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
module BuildMetadatasModule

  # Le fichier yaml, si --from est utilisé
  # Génère une erreur si le fichier est introuvable
  def yaml_file_path
    @yaml_file_path ||= define_yaml_file
  end

  def build_metadatas_from_yaml_file
    require 'yaml'
    ycode = YAML.load(File.read(yaml_file_path))
    ycode || raise_no_code_yaml
    ycode.is_a?(Hash) || raise_code_yaml_invalid(:must_be_an_hash)
    ycode.each do |md_key, md_data|
      MetaData.new(self, md_key, md_data).create
    end
    xfile.save
  end


  # ---------------------------------------------------------------------
  #

  def define_yaml_file
    pth = pth_init = CLI.options[:from]
    pth = File.join(project.folder, pth) unless File.exist?(pth)
    File.exist?(pth) || rt('commands.set.errors.yaml_file_unfound', {pth: pth_init})
    return pth
  end
  # /define_yaml_file
  private :define_yaml_file

end #/module
