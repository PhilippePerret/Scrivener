# encoding: UTF-8
class Scrivener
class Project
class << self

  # Fabrication de l'aide qui sera ajoutée à l'aide définie dans la
  # commande.
  # Elle affiche toutes les propriétés modifiables.
  def aide_commande_set

    puts '
  LISTE DES PROPRIÉTÉS MODIFIABLES
  --------------------------------
  Note 1 : le projet doit être fermé (pas ouvert dans Scrivener)
  Note 2 : plusieurs propriétés peuvent être modifiées en même temps
           par : `scriv set p1="v1" p2="v2"... pN=vN`
    '
    MODIFIABLE_PROPERTIES.collect do |property, dproperty|
      dproperty.key?(:variante) && dproperty[:variante] || dproperty.merge!(variante: '---')
      dproperty.merge!(description: String.truncate(dproperty[:description], 60, {indent: ' '*15}).join(String::RC))
      values_possibles = if dproperty.key?(:values)
        case dproperty[:values]
        when Array
          dproperty[:values].join(', ')
        when Hash
          String::RC +
          dproperty[:values].collect do |val, facons|
            '        Pour %s : %s' % [val, facons.pretty_join]
          end.join(String::RC)
        end
      end
      dproperty.merge!(:valeurs_possibles => if dproperty.key?(:values)
        String::RC + '    Valeurs  : ' + values_possibles
        else '' end
      )
      puts '
  %{property}

    Fonction : %{description}
    Exemple  : %{exemple}
    Variante : %{variante}%{valeurs_possibles}
      ' % dproperty.merge(property: property.to_s.jaune, exemple: ('scriv set "~/projets/pj.scriv" %s=%s' % [property, dproperty[:exemple]]).jaune)
    end.join(String::RC)
  end
  # /aide_commande_set

end #/<< self
end #/Project
end #/Scrivener
