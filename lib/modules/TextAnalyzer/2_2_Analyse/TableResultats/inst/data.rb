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

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
