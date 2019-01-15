# encoding: UTF-8
=begin

  LCP
  version 1.0.0

  Permet d'avoir une instance qui peut renvoyer une liste, son nombre
  d'éléments et son pourcentage par rapport à un nombre
=end

class LCP

  include ModuleForFromYaml

  attr_accessor :list
  attr_accessor :nombre_comp

  def initialize liste, nombre_comp
    self.list = liste
    self.nombre_comp = nombre_comp
  end

  def yaml_properties
    {
      no_date: true,
      dispatched: {
        nombre:       {type: YIVAR},
        pourcentage:  {type: YIVAR},
        list:         {type: YAPROP}
      }
    }
  end

  def nombre
    @nombre ||= list.count
  end
  alias :count :nombre

  def pourcentage
    @pourcentage ||= (nombre.to_f / nombre_comp).pourcentage.rjust(6)
  end
  alias :pct :pourcentage

end
