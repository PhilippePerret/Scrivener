# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  # Retourne TRUE si le fichier marshal existe
  def exist?
    File.exist?(yaml_file_path)
  end

  def yaml_file_path
    @yaml_file_path ||= File.join(analyse.hidden_folder, 'whole_text.yaml')
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
