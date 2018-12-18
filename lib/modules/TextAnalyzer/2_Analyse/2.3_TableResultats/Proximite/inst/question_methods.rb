# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats
class Proximite

  # Retourne TRUE si les deux mots sont dans le même fichier texte
  def in_same_file?
    @mot_are_in_same_file ||= mot_apres.document == mot_avant.document
  end

  def fixed?
    self.fixed == true
  end
  def erased?
    self.erased == true
  end
  def ignored?
    self.ignored == true
  end

end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
