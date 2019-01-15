# encoding: UTF-8
class Scrivener

  extend ModuleFPath

class << self

  # Retourne le path relatif (dans l'application de commande Scrivener) pour
  # le path +full_path+. Si +line_number+ est fourni, on l'ajoute au bout
  # du path. C'est le numéro de ligne dans le fichier
  # Sert pour tous les messages d'erreur
  def relative_path full_path, line_number = nil
    '.' + full_path[base_length..-1] + (line_number ? "::#{line_number}" : '')
  end

  def base_length
    @base_length ||= APPFOLDER.length
  end

  def path
    @path ||= APPFOLDER
  end

end #/<< self
end #/Scrivener
