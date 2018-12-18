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

  # Le dernier index pour une proximité
  attr_accessor :last_id_proximite


  attr_accessor :created_at, :updated_at

  def canons # avant, c'était tableau_proximites[:mots]
    @canons ||= Canons.new(self.analyse)
  end

  # La liste de tous les mots réels
  # C'est une table à ne pas confondre avec la liste des mots du texte entier.
  # Celle-ci contient en clé le mot générique (pas canon) en minuscule et
  # en valeur la liste des index de tous les mots identiques du texte.
  def mots # avant, c'était tableau_proximites[:real_mots]
    @mots ||= Mots.new(self.analyse)
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
