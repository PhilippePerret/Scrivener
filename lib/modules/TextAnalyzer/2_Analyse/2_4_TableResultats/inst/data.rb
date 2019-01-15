# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  # Pour la gestion des données YAML
  include ModuleForFromYaml

  # Au cours d'une analyse de plusieurs textes constituant un même texte (comme
  # dans un projet Scrivener), on maintient l'offset courant dans cette
  # propriété mise à 0 à l'initialisation de l'instance TableResultats.
  attr_accessor :current_offset

  # L'index du mot courant traité, quels que soient les documents qu'on
  # analyse.
  attr_accessor :current_index_mot

  # Le dernier index pour une proximité
  attr_accessor :last_id_proximite

  # Version d'analyser utilisée
  attr_accessor :text_analyzer_version

  # Définitions des données qui seront sauvées dans la table de
  # résultat
  def yaml_properties
    self.text_analyzer_version ||= TextAnalyzer.current_version
    {
      datas: {
        text_analyzer_version:  {type: YAPROP},
        current_offset:         {type: YAPROP},
        current_index_mot:      {type: YAPROP},
        last_id_proximite:      {type: YAPROP},
        canons:                 {type: :method},
        mots:                   {type: :method},
        proximites:             {type: YFDATA},
        # segments:               {type: YFDATA}
      }
    }
  end

  def canons
    @canons ||= Canons.new(self.analyse)
  end
  def canons_for_yaml
    nil
  end
  def canons_from_yaml(hdata)

  end

  # La liste de tous les mots réels
  # C'est une table à ne pas confondre avec la liste des mots du texte entier.
  # Celle-ci contient en clé le mot générique (pas canon) en minuscule et
  # en valeur la liste des index de tous les mots identiques du texte.
  def mots
    @mots ||= Mots.new(self.analyse)
  end
  def mots_for_yaml
    mots.data_for_yaml
  end
  def mots_from_yaml(hdata)
    mots.data_from_yaml(hdata)
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
