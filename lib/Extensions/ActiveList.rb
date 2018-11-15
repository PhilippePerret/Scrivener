=begin

  ActiveList
  Version: 1.0.0
  Author:  philippe.perret@yahoo.fr

  Gestion intelligente des listes.

  Initialisation
  --------------
    al = ActiveList.new([<liste Array>][, <owner>])

    Ensuite, on peut appeler chaque item de la liste pour récupérere une
    propriété par :
      al.<property> # => liste des valeurs de la propriété
    ou exécuter une méthode sur chaque item :
      al.<method>  # => Exécute <method> sur chaque élément.

    al.find(args)     Retourne le premier élément répondant aux arguments args.
                      Où +args+ est un hash de `property: value`
    al.find_all(args) Idem, mais retourne tous les éléments.
    al.exist?(args)   Retourne true si l'élément correspondant à +args+ existe.

    Et bien sûr, on peut utiliser toutes les méthodes d'énumération habituelles,
    :each, :collect, :map, etc.

=end
class ActiveList
  # Instance qui possède la liste
  attr_accessor :owner
  attr_accessor :items
  def initialize items = nil, owner = nil
    self.owner = owner
    self.items = items || Array.new
  end

  # On passe par ici lorsque l'instance ActiveList ne connait pas la méthode
  # demandée. Cela se produit lorsqu'on chaine avec un attribut ou une méthode
  # d'un item de la liste. Il faut alors jouer la méthode ou retourner la
  # liste des résultats obtenus.
  # Par exemple, si `project.folders` est une ActiveList, et qu'on invoque
  # `project.folders.name` alors la propriété `name` est cherchée sur les
  # items des project.folders et la liste est retourné avec ces items.
  # Si on invoque `project.folders.delete`, et que la méthode `delete` existe
  # pour les folders, alors les dossiers sont tous délétés.
  def method_missing method_name, *args, &block
    # puts 'method missing : %s' % method_name.inspect
    an_item || raise('Impossible de trouver un item dans liste.')
    if an_item.respond_to?(method_name)
      items.collect { |item| item.send(method_name) }
    elsif items.respond_to?(method_name) # p.e. :each, :collect…
      run_on_each_item(method_name)
    else
      raise ArgumentError.new('La méthode :%s est inconnue des instances %s.' % [method_name, an_item.class.name])
    end
  end

  def run_on_each_item method_name
    items.send(method_name) { |item| yield item }
  end

  def add item
    items << item
  end
  alias :<< :add

  # Retourne true si un élément de la liste comprend les arguments +attrs+
  def exist? attrs
    find(attrs) != nil
  end
  alias :exists? :exist?

  # Retourne le premier élément de la liste correspondant aux attributs attrs.
  def find attrs
    item_found = true
    items.each do |item|
      bad = false
      attrs.each do |k, v|
        item.send(k) == v || begin
          bad = true
          break # on peut passer à l'item suivant
        end
      end
      bad || (return item)
    end
    return nil
  end
  # Retourne tous les éléments de la liste qui répondent aux attributs attrs
  def find_all attrs

  end

  # Retourne le premier item de la liste, s'il existe
  def an_item
    items.first
  end

end
