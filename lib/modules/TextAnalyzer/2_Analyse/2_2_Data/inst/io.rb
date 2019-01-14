# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data

  def exist?
    File.exist?(path)
  end

  def path
    @path ||= File.join(analyse.hidden_folder,'data.yaml')
  end
  alias :yaml_file_path :path # pour le module YAML

end #/Data
end #/Analyse
end #/TextAnalyzer
