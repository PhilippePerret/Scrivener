# encoding: UTF-8
=begin

  Note : ce module contient aussi la class Mots

=end
class TextAnalyzer
class Analyse
class TableResultats

  # Ajouter un mot (traitable ou non) à la table des résultats pendant la
  # relève des mots (cf. module `releve_mots.rb`)
  def add_mot(mot)
    mot.treatable? && add_mot_traitable(mot)
    mots.create(mot) # cf. ci-dessous
  end
  # /add_mot


  # ---------------------------------------------------------------------
  #   CLASS Mots

  # Classe de la liste des mots
  # C'est l'instance obtenue par <analyse>.table_resultats.mots
  class Mots < Hash
    attr_accessor :analyse

    def initialize ianalyse
      self.analyse = ianalyse
    end

    # Ajouter le mot quoi qu'il en soit (traitable ou pas)
    #
    # Ici, on ne traite comme unique que les singuliers/pluriels et les
    # masculins/féminins. Par exemple
    def create(mot)
      # On l'ajoute à la list
      self.key?(mot.lemma) || begin
        self.merge!(mot.lemma => Array.new)
      end
      # On ajoute le mot ici dans le hash
      self[mot.lemma] << mot.index
    end
    # /create

    # Retourne la liste Array des mots uniques
    def mots_uniques
      @mots_uniques ||= begin
        self.select do |mot_min, arr_indexes|
          arr_indexes.count == 1
        end.keys
      end
    end

    # Retourne un ListCountPour des mots différents
    # @usage:
    #   uniques.count   => nombre
    #   uniques.pct     => pourcentage
    #   uniques.list    => liste
    def uniques
      @uniqs ||= LCP.new(mots_uniques, nombre_total_mots)
    end

    # Retourne la liste Array des mots différents
    def differents
      @mots_differents ||= LCP.new(self.keys, nombre_total_mots)
    end

    # Nombre total de mots différents
    def nombre
      @nombre ||= self.count
    end

    # Raccourci
    def nombre_total_mots
      @nombre_total_mots ||= analyse.texte_entier.mots.count
    end

  end #/Mots

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
