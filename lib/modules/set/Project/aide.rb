# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
class Project
class << self

  # Le fichier localisé des données en fonction de la lang
  def modifiable_properties
    @modifiable_properties ||= begin
      YAML.load(File.read(File.join(APPFOLDER,'config','locales','extra','set',Scrivener.lang.to_s,'properties_definition.yml')))
    end
  end

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

    # Le modèle
    property_template = modifiable_properties['template']

    # puts "modifiable_properties: #{modifiable_properties.inspect}"
    modifiable_properties['properties'].each do |property, dproperty|

      # Si une commande à été précisée, on filtre seulement celles qui peuvent
      # correspondre. C'est-à-dire celle qui match avec le filtre fourni.
      filtre && ( property.match(filtre) || next )

      # Certaines méthodes de formatage en ont besoin
      dproperty.merge!('property' => property)

      # On construit le bloc d'aide pour cette propriété
      str_aide << property_template % {
        fproperty:      (dproperty['real'] || property).jaune,
        fvariante:      formated_variante(dproperty),
        fnotyamlfile:   formated_in_or_not_in_yaml_file(dproperty),
        fname:          formated_name(dproperty),
        fdescription:   formated_description(dproperty),
        fexample:       formated_example(dproperty),
        fdefault:       formated_default(dproperty),
        fexpected:      formated_expected_values(dproperty)
      }
    end

    str_aide << String::RC * 4
    str_aide << t('helps.set.mode_utilisation')

    INDENT + str_aide.join(String::RC + INDENT)
  end
  # /aide_commande_set

  def formated_variante(d)
    if d.key?('variante') && d['variante'].key?(Scrivener.lang.to_s)
      " / #{d['variante'][Scrivener.lang.to_s]}"
    else
      ''
    end
  end

  def formated_name(d)
    d['hname']
  end
  def formated_description(d)
    d.key?('description') || raise(ForBlankValue)
    desc = d['description']
    d.key?('extra_description') && desc += ' ' + d['extra_description']
    @indentation_description ||= ' ' * 21
    String.truncate(desc, 60, {indent: @indentation_description}).join(String::RC)
  rescue ForBlankValue
    return '---'
  end

  def formated_expected_values(d)
    if d['method_values']
      send(d['method_values'].to_sym).inspect
    else
      case d['values']
      when String
        d['values']
      when Hash
        d['values'].collect do |k, v|
          '%s -> %s' % [k, v.inspect]
        end.join(String::RC + @indentation_description)
      when nil
        '---'
      end
    end
  end

  # S'il y a une property 'real', on doit l'utiliser. Mais noter qu'il
  # peut y en avoir plusieurs, séparées par des virgules
  def one_real_property(d)
    d['real'] || (return d['property'])
    d['real'].split(',').collect{|e|e.strip}.first
  end

  def formated_example(d)
    d.key?('exemple') || d['exemple_yaml'] || raise(ForBlankValue)
    formated_exemple_command_line(d) + formated_example_yaml(d)
  rescue ForBlankValue
    return '---'
  end

  def formated_exemple_command_line(d)
    d['exemple'] || raise(ForBlankValue)
    d['exemple'].is_a?(Array) || d['exemple'] = [d['exemple']]
    d['exemple'].collect do |ex|
      ('scriv set %s=%s' % [one_real_property(d), ex]).mauve
    end.join(String::RC + @indentation_description)
  rescue ForBlankValue
    return '---'
  end

  def formated_example_yaml(d)
    d['exemple_yaml'] || raise(ForBlankValue)
    d['exemple_yaml'].is_a?(Array) || d['exemple_yaml'] = [d['exemple_yaml']]
    "#{String::RC}#{INDENT * 2}YAML File      : "+
    d['exemple_yaml'].collect do |ex|
      "#{one_real_property(d)}: #{ex}"
    end.join(String::RC + @indentation_description)
  rescue ForBlankValue
    return ''
  end

  def formated_default(d)
    d['default'] || raise(ForBlankValue)
    ' / %s %s' % [t('default_.min'), d['default']]
  rescue ForBlankValue
    return ''
  end

  def formated_in_or_not_in_yaml_file(d)
    d['not_in_yam_file'] || d['only_in_yaml_file'] || raise(ForBlankValue)
    if d['not_in_yam_file']
      @mark_not_in_yaml_file  ||= "    (#{t('notices.only_in_command_line')}, #{t('files.notices.not_in_yaml_file')})".rouge
    else
      @mark_only_in_yaml_file ||= "    (#{t('files.notices.only_in_yaml_file')}, #{t('notices.not_in_command_line')})".rouge
    end
  rescue ForBlankValue
    return ''
  end



  def compile_output_valid_values
    XMLCompile::OUTPUT_FORMATS.collect do |kfmt, dformat|
      '%s %s %s' % ["'#{kfmt.to_s}'", t('for.min'), dformat[:hname]]
    end.join(', ')
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
