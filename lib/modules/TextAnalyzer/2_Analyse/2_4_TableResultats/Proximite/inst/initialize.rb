# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats
  class Proximite

    attr_accessor :id
    attr_accessor :mot_avant, :mot_apres
    attr_accessor :analyse

    # Instanciation d'une nouvelle proximité
    def initialize ianalyse, id, mot_avant, mot_apres
      self.analyse    = ianalyse
      self.id         = id
      self.mot_avant  = mot_avant
      self.mot_apres  = mot_apres
    end

  end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
