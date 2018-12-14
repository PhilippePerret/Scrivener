# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats

  # Ajoute l'instance +mot+ à la table des résultats
  def add_mot_traitable(mot)
    canons.exist?(mot) || self.canons.create(mot)
    # Placer le mot au bon endroit dans la liste des items
    if canons.of(mot)[:items].empty? || canons.of(mot)[:items].last.offset < mot.offset
      # S'il n'y a pas encore d'item ou que le dernier item a un offset inférieur
      # au mot courant, on met le mot courant à la fin.
      canons.add_item(mot)
    else
      # Sinon, il faut trouver où mettre l'item
      canon.of(mot)[:items].each_with_index do |imot, index_mot|
        if imot.offset > mot.offset
          canons.insert_item(mot, index_mot)
          break
        end
      end
    end
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

    # Retourne le Hash ({:items, :proximites}) des données du canon du
    # mot +mot+
    def of mot
      self[mot.canon]
    end

    # Pour créer un nouveau canon
    def create mot
      self.merge!(mot.canon => {items: Array.new, proximites: Array.new})
    end

    # Pour ajouter un item
    def add_item mot
      self[mot.canon][:items] << mot
    end
    # /add_item

    def add_proximite mot_avant, iprox
      canon = mot_avant.canon
      current_proxs = self[canon][:proximites]
      last_prox_id  = current_proxs.last
      last_prox     = last_prox_id ? proximites[last_prox_id] : nil
      if last_prox.nil? || mot_avant.offset > last_prox.mot_avant.offset
        self[canon][:proximites] << iprox.id
      else
        current_proxs.each_with_index do |pid, indexp|
          if mot_avant.offset < proximites[pid].mot_avant.offset
            self[canon][:proximites].insert(indexp, new_prox_id) and break
          end
        end
      end
    end
    # /add_proximite

    # Raccourci
    def proximites
      @proximites ||= self.analyse.table_resultats.proximites
    end

    # Pour insérer le mot +mot+ à la place +index+
    def insert mot, index
      self[mot.canon][:items].insert(index, mot)
    end

    # Retourne True si la canon +canon+ est connu
    # +canon+ Soit le canon ({String}) soit le mot {Mot}
    def exist? canon
      canon.is_a?(String) || canon = canon.canon
      self.key?(canon)
    end

  end #/Canons

end #/TableResultats
end #/Analyse
end #/TextAnalyzer
