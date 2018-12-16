

class String

  # Retourne true si le path (self) existe en tant que fichier ou
  # dossier
  def exists?
    File.exist?(self)
  end

  # Retourne true si self est un fichier
  def file?
    File.exist?(self) && !File.directory?(self)
  end

  # Retourne true si self est un dossier
  def folder?
    File.exist?(self) && File.directory?(self)
  end

end
