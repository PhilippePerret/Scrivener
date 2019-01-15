# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class WholeText
class Mots

  # Pour la gestion des données YAML
  include ModuleForFromYaml

  # {TextAnalyzer::Analyse::WholeText} Instance du texte entier
  attr_accessor :texte_entier

  # {Hash} Liste des mots du texte. En clé, l'index (unique) du mot, en
  # valeur, son instance WholeText::Mot
  # Cf. la méthode `create` pour voir comment ils sont créés
  attr_accessor :items


  # Pour la gestion des données en YAML
  def yaml_properties
    {
      dispatched: {
        count:            {type: YIVAR},
        items:            {type: :method},
        en_proximites:    {type: YFDATA},
        hors_proximites:  {type: YFDATA}
      }
    }
  end

  # Pour l'enregistrement et le chargement des mots
  def items_for_yaml
    h = Hash.new
    items.each { |mid, mdata| h.merge!(mid => mdata.data_for_yaml) }
    return h
  end
  def items_from_yaml(hdata)
    self.items = Hash.new
    hdata.each { |mid, mdata| self.items.merge!(mid => Mot.new(mid, mdata)) }
  end
  def count
    @count ||= items.count
  end
  alias :nombre :count

  # Liste des mots (instances)
  def list
    self.items.values
  end

  # Raccourci
  def pourcentage_utilisation
    self.items.first.pourcentage_utilisation
  end

  # Retourne le LCP des mots en proximité
  def en_proximites
    @en_proximites || calcule_mots_hors_et_en_proximites
    @en_proximites
  end
  def hors_proximites
    @hors_proximites || calcule_mots_hors_et_en_proximites
    @hors_proximites
  end

  def calcule_mots_hors_et_en_proximites
    @en_proximites = Array.new
    @hors_proximites = Array.new
    self.items.each do |index_mot, imot|
      if imot.en_proximite?
        @en_proximites << index_mot
      else
        @hors_proximites << index_mot
      end
    end
    @en_proximites    = LCP.new(@en_proximites, nombre)
    @hors_proximites  = LCP.new(@hors_proximites, nombre)
  end

end #/Mots
end #/WholeText
end #/Analyse
end #/TextAnalyzer
