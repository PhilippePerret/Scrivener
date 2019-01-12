# encoding: UTF-8
=begin

  Lorsqu'on utilise scriv build metadata

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
    ycode || rt('files.errors.no_yaml_code')
    ycode.is_a?(Hash) || rt('metadata.errors.invalid_yaml_code', {error: t('values.errors.must_be_an_hash')})
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
    File.exist?(pth) || rt('files.errors.yaml_file_unfound', {pth: pth_init})
    return pth
  end
  # /define_yaml_file
  private :define_yaml_file

end #/module
