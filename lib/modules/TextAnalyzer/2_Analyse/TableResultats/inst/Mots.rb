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
  class Mots
    attr_accessor :analyse
    attr_accessor :items_downcases
    def initialize ianalyse
      self.analyse = ianalyse
      self.items_downcases = Hash.new # table mot.downcase => instance TableResultats::Mot
    end


    # Ajouter le mot quoi qu'il en soit (traitable ou pas)
    def create(mot)
      # On l'ajoute à la list
      self.items_downcases.key?(mot.downcase) || begin
        self.items_downcases.merge!(mot.downcase => Mot.new(mot))
      end
      self.items_downcases[mot.downcase] << mot
    end
    # /create

    # Pour que l'instance fonctionne comme Canon et Proximite dans les
    # traitement des listes
    def values
      @values ||= self.items_downcases.values
    end
    # Pour récupérer un mot
    # @usages:
    #   <analyse>.mots.get_by_index(<index>)
    #   <analyse>.mots[<index>]
    #   <analyse>.mot(<index>)
    def get_by_index index
      self.items[index]
    end
    alias :[] :get_by_index

  end #/Mots

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
