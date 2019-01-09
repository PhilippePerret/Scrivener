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

module ModuleSetValuesWithKeys

  # = main =
  #
  def set_values
    keys_to_set.each do |key, value|
      method = ('set_%s' % key.to_s).to_sym
      if self.respond_to?(method)
        send(method, value)
      else
        puts (ERRORS[:unknown_method] % key).rouge
      end
    end
  end

  # Retourne une liste de paires [propriété, valeur]
  def keys_to_set
    @keys_to_set ||= begin
      CLI.params.keys.select{|k| k.is_a?(Symbol)}.collect do |sk|
        [real_setter_key(sk), CLI.params[sk].to_s.strip]
      end
    end
  end

end
