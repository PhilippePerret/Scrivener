# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats
  class Proximites < Hash

    attr_accessor :analyse

    def initialize ianalyse
      self.analyse = ianalyse
    end

    # Pour ajouter une proximité
    def << iprox
      self.merge!(iprox.id => iprox)
    end

  end #/Proximites
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
