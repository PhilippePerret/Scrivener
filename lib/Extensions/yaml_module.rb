# frozen_string_literal: true
# encoding: UTF-8
=begin

  Module permettant de gérer les enregistrements d'instance dans des
  fichiers YAML sans passer par Marshal.

  REQUIS
  ------

    L'instance doit définir

        *** une propriété `yaml_file_path`

    qui doit contenir le path au fichier yaml dans lequel enregistrer
    les données.

        *** une méthode `yaml_properties`

    qui va définir les propriétés à exporter et comment les exporter.

    def yaml_properties
      @yaml_properties ||= {
        # Property to dispatch on load
        dispatched: {
          <prop>: {regular: true/false},
          <prop>: {regular: true/false},
          ...
          <prop>: {regular: true/false}

        }
      }
    end

    Avec ces deux propriétés/méthodes définies, il suffit de faire :

        write_in_yaml

    pour enregistrer les données et

        read_from_yam

    pour les recharger.

  TRAITEMENT DES DONNÉES SIMPLES
  ------------------------------
  Les données simples peuvent être simplement définies par :

    <prop> => {type: <type de la propriété>}
    ou
    <prop> => {value: <explicit value>}

    Le type peut être :
      :accessible_property      Si c'est une propriété accessible par send.
      :method                   Si on l'atteint par :<prop>_for_yaml et
                                :<prop>_from_yaml.
      :instance_variable        Si c'est une @variable d'instance

  La méthode "for yaml" fera hdata[dispatched].merge!(<prop> => send(<prop>))
  La méthode "from yaml" fera send("<prop>=", <value>) (ou instance_variable_set)

  TRAITEMENT DES DONNÉES COMPLEXES
  --------------------------------
  Il peut s'agir par exemple d'une propriété qui est une liste d'instance
  d'une autre classe.

  L'instance doit contenir une méthode
    <prop>_for_yaml
  qui va traiter les données pour l'enregistrement et une méthode
    <prop>_from_yaml
  qui va traiter les données en entrée dans l'instance.

  NOTES
  -----

  Le module ajoute automatiquement les propriétés avec accesseurs
  :created_at et :updated_at et les renseigne. Donc inutile de les
  traiter dans les instances.

=end
module ModuleForFromYaml

  attr_accessor :created_at, :updated_at

  # La méthode pour enregistrer
  #   les données définies dans `yaml_properties` par l'instance
  #   appelante
  #   dans le fichier yaml défini par `yaml_file_path` par l'instance
  #   appelante
  #
  # alias de `save`
  def write_in_yaml
    self.respond_to?(:yaml_file_path) || rt('system.errors.required_instance_method', {method_name: ':yaml_file_path', class_name: self.class.name})
    File.open(yaml_file_path,'wb'){|rf| YAML.dump(data_for_yaml, rf)}
  end
  alias :save :write_in_yaml

  # Méthode inverse de la précédente. Elle lit les données dans le fichier
  # YAML yaml_file_path et les dispatche dans l'instance.
  #
  # alias de `load`
  def read_from_yaml
    File.exist?(yaml_file_path) || rt('files.errors.yaml_file_unfound')
    data_from_yaml(YAML.load(File.read(yaml_file_path)))
  end
  alias :load :read_from_yaml

  def data_for_yaml
    hdata = Hash.new
    # Les données fonctionnelles, qui permettent de connaitre les
    # éléments
    hdata.merge!(
      class:      self.class.name
    )
    # On enregistre les propriétés non dispatchée (qui servent souvent de
    # simple rappel)
    yaml_properties.each do |prop, value|
      prop != :dispatched || next
      hdata.merge!(prop => value)
    end
    hdata.merge!(dispatched: Hash.new)
    yaml_properties[:dispatched].each do |prop, dprop|
      # dprop peut définir des façons particulières de traiter la donnée
      # pour l'enregistrer
      def_value = dprop[:value] ||  case dprop[:type]
                                    when :accessible_property
                                      send(prop)
                                    when :variable_instance
                                      self.instance_variable_get("@#{prop}")
                                    when :method
                                      dprop[:value] || send("#{prop}_for_yaml".to_sym)
                                    else
                                      rt('system.errors.unknown_type', {type: dprop[:type], method: ':data_for_yaml'})
                                    end
      hdata[:dispatched].merge!(prop => def_value)
    end
    # Pour terminer, on ajoute les dates de création (si nécessaire) et de
    # dernière modification
    self.created_at || hdata[:dispatched].merge!(created_at: Time.now)
    hdata[:dispatched].merge!(updated_at: Time.now)

    # On peut retourner les données à enregistrer dans le fichier YAML
    return hdata
  end

  def data_from_yaml(hdata)
    hdata[:dispatched].each do |prop, value|
      data_properties = yaml_properties[prop.to_sym]
      case data_properties[prop][:type]
      when :accessible_property
        method = "#{prop}="
      when :instance_variable
        self.instance_variable_set("@#{prop}", value)
        next
      when :method
        method = "#{prop}_from_yaml"
      when nil
        next
      end
      send(method.to_sym, value)
    end
  end

end
