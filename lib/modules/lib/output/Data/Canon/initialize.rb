=begin

  Classe Scrivener::Project::Canon
  Pour la gestion pratique des canons

=end
class Scrivener
class Project
class Canon

  # L'instance Scrivener::Project du projet du canon
  attr_reader :projet

  # Le terme canonique
  attr_accessor :canon

  # Les données du canon, telles que définies dans
  # projet.tableau_proximites[:mots]
  attr_accessor :data

  def initialize iproj, canon, data
    @projet     = iproj
    self.canon  = canon
    self.data   = data
  end

  def items
    @items ||= data[:items]
  end
  def nombre_occurences
    @nombre_occurences ||= items.count
  end

  def proximites
    @proximites ||= data[:proximites]
  end
  def nombre_proximites
    @nombre_proximites ||= proximites.count
  end

end #/Canon
end #/Project
end #/Scrivener
