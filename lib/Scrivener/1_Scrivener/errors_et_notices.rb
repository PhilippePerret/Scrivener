# encoding: UTF-8
class Scrivener

  # Classe d'erreur qu'on utilise pour retourner une chaine vide ou nil
  # Par exemple :
  # def return_definition(d)
  #   d.key?(:definition) || raise(ForBlankValue)
  #   ...
  # rescue ForBlankValue
  #   return ''
  # end
  #
  class ForBlankValue < StandardError ; end

end #/Scrivener
