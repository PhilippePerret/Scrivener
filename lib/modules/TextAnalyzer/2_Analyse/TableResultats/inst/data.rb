# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  # Au cours d'une analyse de plusieurs textes constituant un même texte (comme
  # dans un projet Scrivener), on maintient l'offset courant dans cette
  # propriété mise à 0 à l'initialisation de l'instance TableResultats.
  attr_accessor :current_offset

  # L'index du mot courant traité, quels que soient les documents qu'on
  # analyse.
  attr_accessor :current_index_mot

  def canons # avant, c'était tableau_proximites[:mots]
    @canons ||= Canons.new(self.analyse) # peut-être, plus tard, une classe propre
  end

  # La liste de tous les mots réels
  def mots # avant, c'était tableau_proximites[:real_mots]
    @mots ||= Mots.new(self.analyse) # Peut-être, plus tard, une classe propre
  end

  # Liste {Segments} des segments de texte dans le texte total. Chaque segment
  # peut être un mot ou un inter-mot, comme une ponctuation. Cette liste
  # de segments permet de reconstituer tout le texte.
  def segments
    @segments ||= Segments.new(self.analyse)
  end

  # La liste des proximités
  # C'est une instance qui permet de gérer les proximités plus facilement
  def proximites
    @proximites ||= Proximites.new(self.analyse)
  end

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
