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
    tit =  "#{t('app.titles.modifiable_property_list')}#{filtre ? " (#{t('filtred.fem.cap.plur')})".bleu : ''}\n"
    str_aide = Array.new
    str_aide << tit
    str_aide << "-" * tit.length
    MODIFIABLE_PROPERTIES.each do |property, dproperty|
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
                                '        %s %s : %s' % [t('for.tit'), val, facons.pretty_join]
                              end.join(String::RC)
                            end
                          else
                            '---'
                          end
      dproperty.merge!(:valeurs_possibles => if dproperty.key?(:values)
        String::RC + "  #{'value.tit.plur'}  : " + values_possibles
        else '' end
      )
      if dproperty.key?(:in_yaml_file)
        dproperty[:in_yaml_file] = String::RC + INDENT * 2 + 'YAML file : ' + dproperty[:in_yaml_file]
      else
        dproperty.merge!(in_yaml_file: '')
      end

      if dproperty.key?(:only_in_yaml_file)
        dproperty[:variante] += " (#{t('files.notices.only_in_yaml_file', nil, {color: :rouge})})"
      end
      if dproperty.key?(:exemple) && dproperty[:exemple]
        # dproperty[:exemple] = String::RC + INDENT * 2 + 'Exemple  :' +
        dproperty[:exemple] = ('scriv set "~/projets/pj.scriv" ' + dproperty[:exemple]).jaune
        dproperty[:exemple].prepend(String::RC + INDENT * 2 + "#{t('example.tit.sing')}  : ")
      else
        dproperty[:exemple] = ''
      end

      str_aide << '
  %{property} / %{variante}

    %{fct} : %{description}%{exemple}%{valeurs_possibles}%{in_yaml_file}
      ' % dproperty.merge({ property: (dproperty[:real] || property).to_s.jaune,
                            fct: t('function.tit.sing')
      })
    end

    str_aide << t('helps.set.mode_utilisation')

    INDENT + str_aide.join(String::RC + INDENT)
  end
  # /aide_commande_set


  def compile_output_valid_values
    XMLCompile::OUTPUT_FORMATS.collect do |kfmt, dformat|
      '%s %s %s' % [kfmt.to_s.inspect, t('for.min'), dformat[:hname]]
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
