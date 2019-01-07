# encoding: UTF-8
class Scrivener
class Project
class << self

  # Fabrication de l'aide qui sera ajoutée à l'aide définie dans la
  # commande.
  # Elle affiche toutes les propriétés modifiables.
  # Chaque setter est défini en mettant d'abord dans un tableau ses
  # propriétés qui serviront à construire l'aide.
  def aide_commande_set

   '
  LISTE DES PROPRIÉTÉS MODIFIABLES
  --------------------------------
  Note 1 : le projet doit être fermé (pas ouvert dans Scrivener)
  Note 2 : plusieurs propriétés peuvent être modifiées en même temps
           par : `scriv set p1="v1" p2="v2"... pN=vN`
    ' +
    MODIFIABLE_PROPERTIES.collect do |property, dproperty|
      dproperty.key?(:variante) && dproperty[:variante] || dproperty.merge!(variante: '---')
      dproperty.merge!(description: String.truncate(dproperty[:description], 60, {indent: ' '*15}).join(String::RC))
      if dproperty.key?(:method_values)
        dproperty.merge!(values: send(dproperty[:method_values]))
      end
      values_possibles =  if dproperty.key?(:values)
                            case dproperty[:values]
                            when String
                              dproperty[:values]
                            when Array
                              dproperty[:values].join(', ')
                            when Hash
                              String::RC +
                              dproperty[:values].collect do |val, facons|
                                '        Pour %s : %s' % [val, facons.pretty_join]
                              end.join(String::RC)
                            end
                          else
                            '---'
                          end
      dproperty.merge!(:valeurs_possibles => if dproperty.key?(:values)
        String::RC + '    Valeurs  : ' + values_possibles
        else '' end
      )
      if dproperty.key?(:in_yaml_file)
        dproperty[:in_yaml_file] = String::RC + INDENT * 2 + 'In YAML file : ' + dproperty[:in_yaml_file]
      else
        dproperty.merge!(in_yaml_file: '')
      end

      if dproperty.key?(:only_in_yaml_file)
        dproperty[:variante] += " #{'(seulement dans un fichier YAML)'.rouge}"
      end

      '
  %{property} / %{variante}

    Fonction : %{description}
    Exemple  : %{exemple}%{valeurs_possibles}%{in_yaml_file}
      ' % dproperty.merge(property: (dproperty[:real] || property).to_s.jaune, exemple: ('scriv set "~/projets/pj.scriv" %s=%s' % [property, dproperty[:exemple]]).jaune)
    end.join(String::RC)
  end
  # /aide_commande_set


  def compile_output_valid_values
    XMLCompile::OUTPUT_FORMATS.collect do |kfmt, dformat|
      '%s pour %s' % [kfmt.to_s.inspect, dformat[:hname]]
    end
  end
  # /compile_output_valid_values
  private :compile_output_valid_values

  def inspector_tabs_valid_values
    UI::UICommon::Inspector::ONGLETS.values
  end
  # /inspector_tabs_valid_values
  private :inspector_tabs_valid_values

end #/<< self
end #/Project
end #/Scrivener
