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

  # Pour la gestion des données enregistrées et loadées
  include ModuleForFromYaml

  # Instance {TextAnalyzer::Analyse} de l'analyse à laquelle appartient le
  # canon
  attr_accessor :analyse

  # {String} Le mot canonique
  attr_accessor :canon

  def yaml_properties
    {
      no_date: true,
      datas: {
        canon:              {type: YAPROP},
        proximites:         {type: YIVAR},
        mots:               {type: :method},
        nombre_occurences:  {type: YIVAR},
        nombre_proximites:  {type: YIVAR}
      }
    }
  end

  # Liste des instances mots du canon
  # Note : avant, c'était `items`
  def mots
    @mots ||= Array.new
  end
  def mots_for_yaml
    mots.collect{|imot|imot.data_for_yaml}
  end
  def mots_from_yaml(rdata)
    @mots = Array.new
    adata.each do |hdata|
      imot = Mot.new(analyse)
      imot.data_from_yaml(hdata)
      self.mots << imot
    end
  end

  # Liste des identifiants ({Fixnum}) des proximités du canon
  def proximites
    @proximites ||= Array.new
  end

  def nombre_proximites
    @nombre_proximites ||= proximites.count
  end

  def nombre_occurences
    @nombre_occurences ||= mots.count
  end
  alias :nombre_mots :nombre_occurences

  # Dernier offset, c'est-à-dire offset du dernier mot
  def last_offset
    if empty?
      nil
    else
      self.mots.last.offset
    end
  end

  def moyenne_distances
    @moyenne_distances ||= calc_moyenne_distances
  end

end #/Canon
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
