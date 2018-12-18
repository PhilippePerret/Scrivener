# encoding: UTF-8
=begin

  Classe pour la gestion du texte dans son ensemble, une fois que tous les
  textes d'une analyse ont été rassemblés.

=end
class TextAnalyzer
class Analyse
class WholeText

  # Retourne, s'il existe, l'instance WholeText de l'analyse +analyse+
  def self.load(analyse)
    File.open(analyse.texte_entier.instance_file_path,'rb'){|f| Marshal.load(f)}
  end

  def save
    self.created_at ||= Time.now
    self.updated_at = Time.now
    File.open(instance_file_path, 'wb') { |f| Marshal.dump(self, f) }
  end

  # Retourne TRUE si le fichier marshal existe
  def exist?
    File.exist?(instance_file_path)
  end

  def instance_file_path
    @instance_file_path ||= File.join(analyse.hidden_folder, 'whole_text.msh')
  end

end #/WholeText
end #/Analyse
end #/TextAnalyzer
