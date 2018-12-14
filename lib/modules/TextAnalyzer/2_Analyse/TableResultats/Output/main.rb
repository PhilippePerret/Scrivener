# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats

  # Propriété de la table des résultats
  # @usage: <analyse>.table_resultats.output.<méthode>
  def output
    @output ||= Output.new(self.analyse)
  end

  class Output
    attr_accessor :analyse
    def initialize ianalyse
      self.analyse = ianalyse
    end

  end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
