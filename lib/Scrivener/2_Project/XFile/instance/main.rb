# encoding: UTF-8
=begin
  Instance Scrivener::Project::XFile
  ----------------------------------
  Pour la gestion du fichier .scrivx du projet
=end
class Scrivener
class Project
class XFile

  # Le projet Scrivener::Project auquel appartient le
  # projet.
  attr_reader :projet

  def initialize projet
    @projet = projet
  end

  # Pour enregistrer le texte modifié
  def save
    File.exist?(copy_path) && File.unlink(copy_path)
    FileUtils.move(path, copy_path)
    docfile = File.new(path, 'w')
    xmldoc.write(output: docfile, indent: 2, transitive: true)
    docfile.close rescue nil
    File.exist?(path) && File.unlink(copy_path)
    unset_modified
  end

  def save_if_modified
    modified? && save
  end

  def modified?       ; @modified === true  end
  def set_modified    ; @modified = true    end
  def unset_modified  ; @modified = false   end

  def path
    @path ||= projet.xfile_path
  end

  def copy_path
    @copy_path ||= File.join(projet.path, '%s-backup.scrivx' % projet.affixe)
  end

end #/XFile
end #/Project
end #/Scrivener
