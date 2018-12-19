# encoding: UTF-8
=begin
  Classe TextAnalyzer::Analyse::TableResultats::Canon
  ---------------------------------------------------
  Instance pour les canons (pour UN canon
  )
=end
class TextAnalyzer
class Analyse
class TableResultats
class Canon

  # Pour ajouter le mot +mot+
  def add_mot imot
    if self.empty? || self.last_offset < imot.offset
      self.mots << imot
    else
      self.mots.each_with_index do |m, index_mot|
        if m.offset > imot.offset
          self.insert_mot(imot, index_mot) and break
        end
      end
    end
  end
  # /add_mot

  # Pour ajouter la proximitté +iprox+ {...::Proximite} au canon
  def add_proximite iprox
    last_prox     = proximites.last ? analyse.proximites[proximites.last] : nil
    if last_prox.nil? || iprox.mot_avant.offset > last_prox.mot_avant.offset
      self.proximites << iprox.id
    else
      self.proximites.each_with_index do |pid, indexp|
        if iprox.mot_avant.offset < analyse.proximites[pid].mot_avant.offset
          self.insert_prox(iprox, indexp) and break
        end
      end
    end
  end
  # /add_proximite

  def insert_mot imot, index
    self.mots.insert(index, imot)
  end

  def insert_prox iprox, index
    self.proximites.insert(index, iprox.id)
  end

  def empty?
    self.mots.empty?
  end

end #/Canon
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
