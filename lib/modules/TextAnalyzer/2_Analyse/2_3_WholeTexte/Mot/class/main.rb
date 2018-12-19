class TextAnalyzer
class Analyse
class WholeText
class Mot
  class << self

    def distance_minimale(canon)
      @distances_minimales ||= Hash.new
      @distances_minimales[canon] ||= begin
        if TextAnalyzer::PROXIMITES_MAX[:mots].key?(canon)
          TextAnalyzer::PROXIMITES_MAX[:mots][canon]
        else
          TextAnalyzer::DISTANCE_MINIMALE
        end
      end
    end

  end #/<< self
end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
