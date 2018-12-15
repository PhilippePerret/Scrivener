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

  # Instance {TextAnalyzer::Analyse} de l'analyse à laquelle appartient le
  # canon
  attr_accessor :analyse

  # {String} Le mot canonique
  attr_accessor :canon

  # Liste des instances mots du canon
  # Note : avant, c'était `items`
  def mots
    @mots ||= Array.new
  end

  # Liste des identifiants ({Fixnum}) des proximités du canon
  def proximites
    @proximites ||= Array.new
  end

  # Dernier offset, c'est-à-dire offset du dernier mot
  def last_offset
    if empty?
      nil
    else
      self.mots.last.offset
    end
  end
end #/Canon
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
