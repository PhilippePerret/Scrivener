# encoding: UTF-8
class Scrivener
class Project

  include ModuleSetValuesWithKeys

  # # = main =
  # #
  # # Méthode principale appelée par la méthode Scrivener::Project::exec_set
  # # qui boucle sur toutes les clés et appelle les méthodes pour enregistrer
  # # les données.
  # #
  # # Note : pour créer une nouvelle propriété modifiable, il suffit de
  # # créer sa méthode 'set_<propriété>'
  # def set_values
  #   keys_to_set.each do |key, value|
  #     method = ('set_%s' % key.to_s).to_sym
  #     if self.respond_to?(method)
  #       send(method, value)
  #     else
  #       puts (ERRORS[:unknown_method] % key).rouge
  #     end
  #   end
  # end
  #
  # # Retourne une liste de paires [propriété, valeur]
  # def keys_to_set
  #   @keys_to_set ||= begin
  #     CLI.params.keys.select{|k| k.is_a?(Symbol)}.collect do |sk|
  #       [real_setter_key(sk), CLI.params[sk].to_s.strip]
  #     end
  #   end
  # end

end #/Project
end #/Scrivener
