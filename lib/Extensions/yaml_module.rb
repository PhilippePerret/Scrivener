# frozen_string_literal: true
# encoding: UTF-8
=begin

  Module permettant de gérer les enregistrements d'instance dans des
  fichiers YAML sans passer par Marshal.

  MISE EN PLACE
  -------------

    class ClasseUsingYaml

      include ModuleForFromYaml

      ...

      def yaml_properties
        {
          ...
        }
      end

      def path
        @path ||= '/to/yaml/file.yml'
      end

    end #/ClasseUsingYaml

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
        datas: {
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
      :data_for_yaml            Cela signifie que la propriété est une instance
                                qui répond aux méthode `data_for_yaml` et
                                `data_from_yaml`.

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

    * Le module ajoute automatiquement les propriétés avec accesseurs
      :created_at et :updated_at et les renseigne. Donc inutile de les
      traiter dans les instances.
      Pour ne pas les enregistrer (pour les données à grand nombre), on
      ajoute simplement :no_date au premier niveau de yaml_properties

    * La méthode `inspect` des instances est remplacée par la méthode
      data_for_yaml qui permet d'avoir un affichage plus lisible. On
      peut néanmoins obtenir le vrai inspect avec la méthode
      `real_inspect`

=end
module ModuleForFromYaml

  # Type d'une propriété dans yaml_properties
  # Pour simplifier l'écriture
  YAPROP  = :accessible_property
  YIVAR   = :instance_variable
  YFDATA  = :data_for_yaml


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

  # Les propriétés de premier niveau à passer
  SKIP_ROOT_LEVEL = {
    datas: true, no_date: true
  }

  def data_for_yaml
    hdata = Hash.new
    # Les données fonctionnelles, qui permettent de connaitre les
    # éléments
    hdata.merge!(
      class:      self.class.name
    )
    # Faut-il ou non des dates
    no_date = !!yaml_properties.delete(:no_date)

    # On enregistre les propriétés non dispatchée (qui servent souvent de
    # simple rappel)
    yaml_properties.each do |prop, value|
      SKIP_ROOT_LEVEL[prop] || hdata.merge!(prop => value)
    end
    hdata.merge!(datas: Hash.new)
    yaml_properties[:datas].each do |prop, dprop|
      # dprop peut définir des façons particulières de traiter la donnée
      # pour l'enregistrer
      def_value = dprop[:value] ||  case dprop[:type]
                                    when :accessible_property
                                      send(prop)
                                    when :instance_variable
                                      send(prop) # pour l'évaluer au besoin
                                    when :data_for_yaml
                                      if send(prop) # peut être nil
                                        send(prop).respond_to?(:data_for_yaml) || rt('system.errors.instance_method_required', {class_name: self.class.name, method_name: ':data_for_yaml'})
                                        send(prop).data_for_yaml
                                      end
                                    when :method
                                      dprop[:value] || send("#{prop}_for_yaml".to_sym)
                                    else
                                      rt('system.errors.unknown_type', {type: dprop[:type], method: ':data_for_yaml'})
                                    end
      hdata[:datas].merge!(prop => def_value)
    end

    unless no_date
      # Pour terminer, on ajoute les dates de création (si nécessaire) et de
      # dernière modification
      self.created_at || hdata[:datas].merge!(created_at: Time.now)
      hdata[:datas].merge!(updated_at: Time.now)
    end

    # On peut retourner les données à enregistrer dans le fichier YAML
    return hdata
  end
  # /data_for_yaml

  alias :real_inspect :inspect
  def inspect
    data_for_yaml.to_yaml
  end

  # La méthode qui reçoit les données lues dans le fichier YAML et qui va
  # les dispatcher dans l'instance en fonction de leur type.
  def data_from_yaml(hdata)
    hdata[:datas].each do |prop, value|
      data_properties =
        if yaml_properties[:datas].key?(prop.to_sym)
          yaml_properties[:datas][prop.to_sym]
        else
          case prop
          when :created_at, :updated_at
            {type: YAPROP}
          else
            raise 'La propritété "%s" est intraitable.' % prop.inspect
          end
        end
      # puts "-- data_properties de #{prop.inspect}: #{data_properties.inspect}"
      case data_properties[:type]
      when :accessible_property
        send("#{prop}=".to_sym, value)
      when :instance_variable
        self.instance_variable_set("@#{prop}", value)
      when :data_for_yaml
        if send(prop) # peut être nil
          send(prop).respond_to?(:data_from_yaml) || rt('system.errors.instance_method_required', {class_name: self.class.name, method_name: ':data_from_yaml(hdata)'})
          send(prop).data_from_yaml(value)
        end
      when :method
        send("#{prop}_from_yaml".to_sym, value)
      when nil
        next
      end
    end
  end
  # /data_from_yaml
end
