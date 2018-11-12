

class String

  # Retourne true si le path (self) existe en tant que fichier ou
  # dossier
  def exists?
    File.exists?(self)
  end

  # Retourne true si self est un fichier
  def file?
    File.exists?(self) && !File.directory?(self)
  end

  # Retourne true si self est un dossier
  def folder?
    File.exists?(self) && File.directory?(self)
  end
  
end
