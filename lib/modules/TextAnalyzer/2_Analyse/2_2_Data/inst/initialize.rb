# encoding: UTF-8
=begin

  class TextAnalyzer::Analyse::Data
  ----------------------------------
  Pour conserver les données générales de la dernière analyse, comme les
  dates et les paths

=end
class TextAnalyzer
class Analyse
class Data

  attr_accessor :analyse

  def initialize ianalyse
    self.analyse = ianalyse
  end

end #/Data
end #/Analyse
end #/TextAnalyzer
