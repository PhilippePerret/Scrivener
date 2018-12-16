class TextAnalyzer
class Analyse
class WholeText
class Mot
  class << self

    attr_accessor :items

    # Pour créer un nouveau mot
    #
    # RETURN L'instance Mot, pour ajout aux résultats
    def create data_mot
      imot = new(data_mot)
      @items ||= Hash.new
      @items.merge!(imot.index => imot)
      return imot
    end

    # Pour récupérer un mot
    def get_by_index mot_id
      items[mot_id]
    end
    alias :[] :get_by_index

  end #/<< self
end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
