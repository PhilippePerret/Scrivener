# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
  # Liste des méthodes, pour l'aide
  MODIFIABLE_PROPERTIES = Hash.new

class Project

  def self.add_modpro keyh
    MODIFIABLE_PROPERTIES.key?(keyh) && raise('LA CLÉ %s existe déjà !' % [keyh])
    MODIFIABLE_PROPERTIES.merge!(keyh => true)
    # TODO Plus tard, il faudra peut-être charger les textes localisés en
    # fonction de la langue.
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
        wt('commands.set.errors.unknown_set_method', {prop: key}, {color: :rouge})
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


  # La clé, pour une donnée (p.e. 'title') peut être exprimée dans
  # une autre langue (p.e. 'titre'). C'est ici qu'on fait la rectification
  def real_setter_key(key)
    Scrivener::Project::TABLE_EQUIVALENCE_DATA_SET[key] || key
  end

  # ---------------------------------------------------------------------
  # Méthode fonctionnelles

  def human_value_objectif_to_real_value valeur, raise_if_bad_value
    SWP.signs_from_human_value(valeur, raise_if_bad_value)
  end

  # Retourne la vraie valeur de +value+ en la trouvant dans
  # +data_value+. Si la valeur n'est pas trouvée, une exception
  # est levée.
  # Cette méthode permet par exemple de donner 'Plan' comme valeur
  # et de retourner 'Outliner', le nom du plan dans Scrivener.
  def real_value_in(value, data_value)
    case data_value
    when Array
      # Quand +data_value+ est une liste, on doit juste vérifier que
      # +value+ appartient bien à cette liste
      data_value.include?(value) || raise('La valeur devrait être une parmi : %s' % data_value.join(', '))
    when Hash
      data_value.key?(value) && (return value)
      # Sinon, il faut chercher la bonne valeur
      data_value.each do |real, arr_values|
        arr_values.include?(value) && (return real)
      end
      # Si on arrive ici c'est que la valeur n'a pas été trouvée
      raise('Impossible de trouver la valeur correspond à %s' % value.inspect)
    end
    nil
  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
    false
  end
  def yes_or_no_value value
    case value.to_s.downcase
    when '', 'vrai', 'true', 'yes', 'oui', 'y', 'o' then 'Yes'
    when 'no', 'non', 'n', 'false', 'faux' then 'No'
    else raise 'Valeur yes/no invalide.'
    end
  end

  # Prend n'importe quelle valeur +value+ et la retourne comme un factor
  # Scrivener. Par exemple, `100` qui signifie `100%` vaut 1.0
  def any_value_as_factor(value)
    case value.to_s
    when /^[0-9](\.[0-9]{1,2})?$/ then value # déjà un facteur
    when /^[0-9]{2,3}$/
      (value.to_f / 100).pretty_round
    when /^[0-9]{2,3}%$/
      (value[0...-1].to_f / 100).pretty_round
    else
      rt('errors.unable_to_find_factor_with', {value: value.inspect}, ArgumentError)
    end.to_f
  end

  def confirme key_set, replacements = nil
    msg = MODIFIABLE_PROPERTIES[key_set][:confirmation]
    replacements.nil? || msg = msg % replacements
    puts INDENT_TIRET + msg
  end

end
