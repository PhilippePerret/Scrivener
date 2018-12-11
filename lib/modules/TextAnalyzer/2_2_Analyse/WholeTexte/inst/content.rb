# encoding: UTF-8
=begin

  Classe TextAnalyzer::Analyse::WholeText

  Méthodes de gestion du contenu textuel

=end
class TextAnalyzer
class Analyse
class WholeText

  # Le contenu total du texte de l'analyse
  # Soit il se trouve dans un fichier dans le dossier caché de l'analyse,
  # soit il faut le constuire
  def content
    @content ||= begin
      File.exist?(path) ? File.read(path).force_encoding('utf-8') : ''
    end
  end

  # Pour ajouter une portion de texte au texte complet
  def << portion
    content << portion
  end
  alias :add :<<

end #/WholeText
end #/Analyse
end #/TextAnalyzer
