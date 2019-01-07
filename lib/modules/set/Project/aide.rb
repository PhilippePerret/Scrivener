# frozen_string_literal: true
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
    filtre = nil
    if CLI.params[1]
      filtre = CLI.params[1].downcase.to_sym
      filtre = (TABLE_EQUIVALENCE_DATA_SET[filtre] || filtre).to_s
      filtre = /#{Regexp.escape(filtre)}/i
    end
    str_aide =  INDENT + "LISTE DES PROPRIÉTÉS MODIFIABLES#{filtre ? ' (FILTRÉES)'.bleu : ''}\n"
    str_aide += INDENT + "--------------------------------\n"
    str_aide += MODIFIABLE_PROPERTIES.collect do |property, dproperty|
      # Si une commande à été précisée, on filtre seulement celles qui peuvent
      # correspondre.
      filtre && ( property.match(filtre) || next )
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
        dproperty[:in_yaml_file] = String::RC + INDENT * 2 + 'YAML file : ' + dproperty[:in_yaml_file]
      else
        dproperty.merge!(in_yaml_file: '')
      end

      if dproperty.key?(:only_in_yaml_file)
        dproperty[:variante] += " #{'(seulement dans un fichier YAML)'.rouge}"
      end
      if dproperty.key?(:exemple) && dproperty[:exemple]
        # dproperty[:exemple] = String::RC + INDENT * 2 + 'Exemple  :' +
        dproperty[:exemple] = ('scriv set "~/projets/pj.scriv" ' + dproperty[:exemple]).jaune
        dproperty[:exemple].prepend(String::RC + INDENT * 2 + 'Exemple  : ')
      else
        dproperty[:exemple] = ''
      end

      '
  %{property} / %{variante}

    Fonction : %{description}%{exemple}%{valeurs_possibles}%{in_yaml_file}
      ' % dproperty.merge(property: (dproperty[:real] || property).to_s.jaune)
    end.compact.join(String::RC)

    str_aide += "

  MODE D’UTILISATION
  ------------------

    Deux modes d’utilisation permettent de définir ces propriétés :
    * mode en ligne de commande, où plusieurs propriétés peuvent
      être définies en même temps. Par exemple :
      #{'scriv set notes_zoom=2 target=4000m inspector_visible=n'.jaune}
    * mode fichier, à l'aide d'un fichier YAML contenant les don-
      à modifier et leurs valeurs. Il suffit de faire des lignes de
      définition telles que :
        #{'<propriété>: <valeur>'}
      … où `<propriété>` est la propriété listée ci-dessus. Par
      exemple, le fichier pourrait contenir :
        classeur_visible:    oui
        inspecteur_visible:  non
        zoom_notes:          300%
        zoom_editeur1:       150%
      Il suffit ensuite de jouer la commande :
        #{'scriv set --from=mon/fichier.yaml'.jaune}
      … pour que les données soient modifiées.
      La commande #{'`scriv build config-file`'.jaune} permet de partir
      d'un modèle contenant toutes les valeurs possibles. Ajouter
      l'option `--name=nom_fichier` pour définir un nom de fichier
      propre, dans le cas où plusieurs fichier de configurations se-
      raient envisagés.
    "
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
