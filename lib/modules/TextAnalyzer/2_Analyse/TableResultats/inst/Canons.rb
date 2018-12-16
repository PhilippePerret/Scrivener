# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  # Ajoute l'instance +mot+ à la table des résultats
  def add_mot_traitable(mot)
    canons.exist?(mot) || self.canons.create(mot)
    canons.of(mot).add_mot(mot)
  end
  # /add_mot_traitable


  # ---------------------------------------------------------------------
  #   CLASSE Canons

  # Classe de la liste des canons
  #
  class Canons < Hash
    attr_accessor :analyse
    def initialize ianalyse
      self.analyse    = ianalyse
    end

    # Retourne l'instance {...::Canon} des données du canon du
    # mot +mot+
    def of mot
      self[mot.canon]
    end

    # Pour créer un nouveau canon
    def create mot
      self.merge!(mot.canon => Canon.new(analyse, mot.canon))
    end

    def add_proximite mot_avant, iprox
      self[mot_avant.canon].add_proximite(iprox)
    end
    # /add_proximite

    # Raccourci
    def proximites
      @proximites ||= self.analyse.table_resultats.proximites
    end

    # Retourne True si la canon +canon+ est connu
    # +canon+ Soit le canon ({String}) soit le mot {Mot}
    def exist? canon
      canon.is_a?(String) || canon = canon.canon
      self.key?(canon)
    end

    # Retourne la liste des canons sans proximités
    def sans_proximites
      @sans_proximites || calcule_canons_avec_sans_proxs
      @sans_proximites
    end
    # Retourne la liste des canons avec proximités
    def avec_proximites
      @avec_proximites || calcule_canons_avec_sans_proxs
      @avec_proximites
    end

    def calcule_canons_avec_sans_proxs
      @sans_proximites = Array.new
      @avec_proximites = Array.new
      self.each do |canon, icanon|
        if icanon.proximites.empty?
          @sans_proximites << icanon
        else
          @avec_proximites << icanon
        end
      end
    end

  end #/Canons

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
