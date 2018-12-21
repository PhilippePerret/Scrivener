# encoding: UTF-8
=begin
  Extension de la classe Mot pour la gestion des proximités
  d'un projet Scrivener
=end
class TextAnalyzer
class Analyse
class WholeText
class Mot

  # Quand c'est un projet Scrivener, le Binder-item du mot (donc le document
  # le contenant)
  def binder_item
    @binder_item || get_binder_item_of_mot
  end

  def get_binder_item_of_mot
    mot_file = analyse.files[file_id]
    bi_uuid = File.basename(mot_file.path, File.extname(mot_file.path))
    bitem = project.binder_item(bi_uuid)
    bitem
  end

end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
