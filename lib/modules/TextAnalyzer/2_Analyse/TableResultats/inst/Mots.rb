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
    def create(mot)
      # On l'ajoute à la list
      self.key?(mot.downcase) || begin
        self.merge!(mot.downcase => Array.new)
      end
      self[mot.downcase] << mot.index
    end
    # /create
    
  end #/Mots

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
