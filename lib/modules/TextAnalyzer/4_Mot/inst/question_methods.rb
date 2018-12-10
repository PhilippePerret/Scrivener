class TextAnalyzer
class File
class Text
class Mot

  # Retourne TRUE si le mot est un vrai mot, c'est-à-dire s'il
  # contient des lettres.
  def real_mot?
    @is_real_mot ||= !!downcase.match(/[a-zA-Zçàô]/)
  end

  # Retourne true si le mot est traitable
  # Pour le moment, pour qu'un mot soit traitable, il faut :
  #   - que ce soit vraiment un mot
  #   - que la longueur de sa forme canonique soit de au moins 2 caractères
  #   TODO Qu'il ne fasse pas partie de la liste des mots exclus (liste
  #   à inventer)
  def treatable?
    @is_treatable ||= real_mot? && canonique.length > 2
  end

  # Retourne TRUE si le mot courant est trop proche du mot +imot+ {Mot} qui
  # se trouve (toujours pour le moment) avant le mot.
  def trop_proche_de? imot
    self.offset - imot.offset < distance_minimale
  end

end #/Mot
end #/Text
end #/File
end #/TextAnalyzer
