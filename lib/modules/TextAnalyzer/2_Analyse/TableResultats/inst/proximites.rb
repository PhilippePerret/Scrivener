# encoding: UTF-8
=begin

  Noter que pour les proximités, il existe trois choses :
    - la méthode `calcule_proximites` de la table des résultats qui
      permet de chercher les proximités.
    - la class Proximites (au pluriel) qui permet de consigner les
      proximités.
    - la class Proximite (au singulier) qui est la classe des proximités
      et possède son propre dossier plus bas.

=end
class TextAnalyzer
class Analyse
class TableResultats

  # Méthode principale calculant les proximités dans le texte
  def calcule_proximites
    CLI.debug_entry
    canons.each do |canon, dcanon|
      dcanon.mots.each_with_index do |mot_apres, index_mot|
        index_mot > 0 || next
        mot_avant = dcanon.mots[index_mot - 1]
        mot_apres.trop_proche_de?(mot_avant) || next
        # Si on passe ici, c'est que le mot imot est trop du mot précédent.
        # On doit donc créer une proximité
        Proximite.create(self, mot_avant, mot_apres)
      end
    end
  end
  # /calcule_proximites


  class Proximites < Hash

    attr_accessor :analyse

    def initialize ianalyse
      self.analyse = ianalyse
    end

    # Pour ajouter une proximité
    def << iprox
      self.merge!(iprox.id => iprox)
    end

  end #/Proximites
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
