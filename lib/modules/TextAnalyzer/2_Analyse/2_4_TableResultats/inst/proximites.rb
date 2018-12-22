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
  # Ainsi que les proximités par tranche et la moyenne de proximité
  def calcule_proximites
    CLI.debug_entry
    total_distances = 0
    # Le total des distances, mais seulement pour les mots qui
    # sont à distance normale maximale (1 page)
    total_distances_common = 0

    canons.each do |canon, dcanon|
      dcanon.mots.each_with_index do |mot_apres, index_mot|
        index_mot > 0 || next
        mot_avant = dcanon.mots[index_mot - 1]
        mot_apres.trop_proche_de?(mot_avant) || next
        # Si on passe ici, c'est que le mot imot est trop du mot précédent.
        # On doit donc créer une proximité
        iprox = Proximite.create(self, mot_avant, mot_apres)
        iprox.distance > 0 || begin
          raise('La distance dans une proximité est nulle : %s' % iprox.inspect)
        end
        # On va mettre la PROXIMITÉ PAR TRANCHE et en
        # profiter pour calculer la moyenne d'éloignement
        total_distances += iprox.distance
        tranche = ((iprox.distance / 250) + 1) * 250
        proximites_par_tranches[tranche][:all] += 1
        if iprox.distance_minimale == TextAnalyzer::DISTANCE_MINIMALE
          total_distances_common += iprox.distance
          proximites_par_tranches[tranche][:common] += 1
        end
      end
      # /fin de boucle sur tous les mots du canon
    end
    # /fin de boucle sur tous les canons

    if self.proximites.count > 0
      self.moyenne_eloignements         = (total_distances / self.proximites.count)
      self.moyenne_eloignements_common  = (total_distances_common / self.proximites.count)
    end
  end
  # /calcule_proximites

  def proximites_par_tranches
    @proximites_par_tranches ||= begin
      {
        250   => {all: 0, common: 0},
        500   => {all: 0, common: 0},
        750   => {all: 0, common: 0},
        1000  => {all: 0, common: 0},
        1250  => {all: 0, common: 0},
        1500  => {all: 0, common: 0}
      }
    end
  end


  class Proximites < Hash

    attr_accessor :analyse

    def initialize ianalyse
      self.analyse = ianalyse
    end

    # Pour ajouter une proximité
    def << iprox
      self.merge!(iprox.id => iprox)
    end

    def pourcentage
      @pourcentage ||= (nombre.to_f / analyse.texte_entier.mots.nombre).pourcentage
    end

    # Pour ne pas calculer chaque fois
    def nombre
      @nombre ||= self.count
    end

  end #/Proximites
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
