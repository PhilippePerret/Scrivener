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
  # Noter que pour le moment, on ne garde jamais tout le texte. C'est seulement
  # si on utilise `content` que le contenu complet (qui peut être très long)
  # sera chargé.
  # On tient également à jour la longueur, pour ne pas avoir à la calculer
  # en relevant tout.
  def << portion
    File.open(path,'ab'){|f| f.write portion}
    @length += portion.length
  end
  alias :add :<<

end #/WholeText
end #/Analyse
end #/TextAnalyzer
