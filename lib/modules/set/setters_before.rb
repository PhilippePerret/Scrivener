# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
  # Liste des méthodes, pour l'aide
  MODIFIABLE_PROPERTIES = Hash.new

class Project

  def self.add_modpro h
    MODIFIABLE_PROPERTIES.key?(h.keys.first) && raise('LA CLÉ %s existe déjà !' % [h.keys.first])
    MODIFIABLE_PROPERTIES.merge!(h)
  end

end#/Project
end #/Scrivener
