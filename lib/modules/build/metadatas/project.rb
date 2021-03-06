# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end
class Scrivener
class Project
class << self

  # Si true, on ne fait que simuler l'opération (comme la création des
  # documents par exemple)
  attr_accessor :simulation

  def exec_build thing = nil
    self.simulation = !!CLI.options[:simulate]
    include BuildMetadatasModule
    if CLI.options[:from]
      project.build_metadatas_from_yaml_file
    else
      project.build_metadatas_from_command
    end
  end

end #/<< self
end #/Project
end #/Scrivener
