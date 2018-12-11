# encoding: UTF-8
class TextAnalyzer
class AnalyzedFile
class Text
  BEFORE_TIRET_BADS_ARR = [
    'mi'
  ]
  BEFORE_TIRET_BADS = Hash.new

  AFTER_TIRET_BADS_ARR = [
    'ce', 'je', 'tu', 'il','on',
    'ils',
    'nous', 'vous', 'elle',
    'elles'
    ]
  AFTER_TIRET_BADS = Hash.new

  class << self

    # Indique si les listes sont préparées ou non
    attr_accessor :inited

    def prepare_listes_tirets
      BEFORE_TIRET_BADS_ARR.each do |item|
        BEFORE_TIRET_BADS.merge!(item => true)
      end
      AFTER_TIRET_BADS_ARR.each do |item|
        AFTER_TIRET_BADS.merge!(item => true)
      end
      self.inited = true
    end

  end #<< self
end #/Text
end #/AnalyzedFile
end #/TextAnalyzer
