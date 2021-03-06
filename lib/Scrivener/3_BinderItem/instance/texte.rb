# encoding: UTF-8
require 'date'
class Scrivener
class Project
class BinderItem

  # Le texte du fichier (au format txt simple)
  # ------------------------------------------
  # Il peut être pris de trois endroits différents :
  #   - soit de la variable @texte déjà initialisée
  #   - soit du fichier portant l'UUID dans .scriv/files/
  #     (ce fichier correspond au fichier texte dans scrivener, mais
  #     sans aucun balisage)
  #   - soit du fichier dans Scrivener, qu'il faut traiter pour obtenir
  #     le fichier ci-dessus
  def texte
    @texte ||= begin
      if has_text?
        simple_text_file_uptodate? || build_simple_text_file
        File.read(simple_text_path)
      end
    end
  end
  # /texte

  # Construit le fichier simple text du binder-item
  #
  # Noter que c'est ce fichier-là qui servira pour l'analyse du texte par
  # TextAnalyzer.
  #
  # RETURN true si le fichier a pu être construit, false dans le cas contraire
  def build_simple_text_file
    File.exist?(rtf_text_path) || (return false)
    write_in_file(simple_text, simple_text_path)
    return simple_text_file_exists?
  end
  # /build_simple_text_file

  def simple_text
    @simple_text ||= begin
      # -stdout ci-dessous permet de retourner le texte transformé
      # Noter qu'on supprime toutes les balises qui se trouvent
      # éventuellement dans le fichier, comme des variables Scrivener
      # Le problème, c'est qu'on perdrait la correspondance au niveau des
      # offset des mots, donc on les remplaces par des 'SCRVTAGS'
      str = `textutil -format rtf -convert txt -stdout "#{rtf_text_path}"`
      # On supprime toutes les balises de styles
      str.gsub!(/<\!?\$(.*?)>/,'')
      # On supprime les commentaires Scrivener éventuels
      # {\Scrv_annot ... \end_Scrv_annot}
      str.gsub(/ ?\{\\Scrv_annot(.*?)\\end_Scrv_annot\} ?/,'')
    end
  end
  # /simple_text

  def simple_text_file_exists?
    File.exist?(simple_text_path)
  end
  # Retourne true si le fichier simpletext est actualisé. On le compare
  # à la date du fichier original pour le savoir
  def simple_text_file_uptodate?
    simple_text_file_exists? &&
    File.stat(simple_text_path).mtime > File.stat(rtf_text_path).mtime
  end

end #/BinderItem
end #/Project
end #/Scrivener
