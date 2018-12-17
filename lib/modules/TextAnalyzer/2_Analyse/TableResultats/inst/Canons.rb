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

    # Pourcentage de canons (par rapport au nombre de mots total)
    def pourcentage
      @pourcentage ||= (nombre.to_f / analyse.all_mots.count).pourcentage
    end

    # Retourne le LCP (*) des canons sans proximités
    # (*) Liste, nombre et pourcentage
    def hors_proximites
      @hors_proximites || calcule_canons_avec_sans_proxs
      @hors_proximites
    end
    # Retourne le LCP (*) des canons avec proximités
    # (*) Liste, nombre et pourcentage
    def en_proximites
      @en_proximites || calcule_canons_avec_sans_proxs
      @en_proximites
    end

    def calcule_canons_avec_sans_proxs
      @hors_proximites = Array.new
      @en_proximites = Array.new
      self.each do |canon, icanon|
        if icanon.proximites.empty?
          @hors_proximites << icanon
        else
          @en_proximites << icanon
        end
      end
      @hors_proximites  = LCP.new(@hors_proximites, nombre)
      @en_proximites    = LCP.new(@en_proximites, nombre)
    end

    def nombre
      @nombre ||= count
    end

  end #/Canons

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
