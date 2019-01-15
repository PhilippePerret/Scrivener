# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats
  class Proximite

    attr_accessor :id
    attr_accessor :analyse

    # Instanciation d'une nouvelle proximité
    def initialize ianalyse, id = nil, mot_avant = nil, mot_apres = nil
      self.analyse    = ianalyse
      self.id         = id
      @mot_avant = mot_avant
      @mot_apres = mot_apres
    end

  end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
