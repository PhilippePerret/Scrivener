# encoding: UTF-8
class Scrivener
class Project
class BinderItem

  def set_xfile_modified ; projet.xfile.set_modified end

  def set_modified  ; @modified = true    end
  def modified?     ; @modified === true  end

  # Affecter le titre (le nom du document dans le classeur)
  def title= new_titre
    @title = new_titre
    titletag = XML.get_or_add(node, 'Title')
    titletag.text = new_titre
    set_xfile_modified
  end
  alias :set_title :title=

  # Définir le contenu du fichier RTF
  # TODO Plus tard, on pourra définir d'enregistrer en markdown par exemple
  def content= content, options = nil
    write_in_file(content, txt_text_path)
    File.exist?(txt_text_path) || rt('files.errors.file_should_be_created', {pth: txt_text_path})
    `textutil -format txt -convert rtf -output "#{rtf_text_path}" "#{txt_text_path}"`
    File.exist?(rtf_text_path) || rt('files.errors.file_should_be_created', {pth: rtf_text_path})
    File.unlink(txt_text_path)
  end
  alias :set_content :content=

  # Mettre le binder-item à la poubelle
  # -----------------------------------
  # Note : pour faire les deux opérations, il suffit de mettre le nœud
  # dans le dossier trash.
  def throw_in_the_trash
    nchildren = XML.get_or_add(projet.xfile.trashfolder, 'Children')
    nchildren.add_element(self.node)
  end

end #/BinderItem
end #/Project
end #/Scrivener
