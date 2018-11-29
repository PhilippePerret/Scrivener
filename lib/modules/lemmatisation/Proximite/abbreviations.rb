class Proximite
class << self

  def open_file_abbreviations
    if File.exist?(TREE_TAGGER_ABBREVIATES)
      puts 'Taper la commande `vim "%s"` éditer le fichier dans Vim.' % TREE_TAGGER_ABBREVIATES
      backup_original_abbreviations unless backup_abbreviations_exist?
      puts '
      Attention, il s’agit du fichier de la commande Tree-Tagger
      elle-même. En cas de problème, revenez à la liste originale
      en récupérant le fichier original avec la commande :
      `scriv lemma abbreviations --initial # (ou -i)`.
      '.bleu
    else
      raise 'Le fichier des abbréviations est introuvable. Vous devez définir correctement le chemin d’accès au dossier TreeTagger dans le fichier `./config/config.rb`.'
    end
  end

  def backup_original_abbreviations
    unless backup_abbreviations_exist?
      FileUtils.cp(TREE_TAGGER_ABBREVIATES, abbreviations_copied_file_path)
    end
  end
  def backup_abbreviations_exist?
    File.exist?(abbreviations_copied_file_path)
  end
  def retrieve_original_abbreviations
    if File.exist?(abbreviations_copied_file_path)
      File.exist?(TREE_TAGGER_ABBREVIATES) && File.unlink(TREE_TAGGER_ABBREVIATES)
      FileUtils.mv(abbreviations_copied_file_path, TREE_TAGGER_ABBREVIATES)
      puts 'Fichier des abbréviations initiales récupéré.'.bleu
    else
      puts 'Aucun fichier d’abbréviations original existe.Elle n’ont pas dû être modifiées'.rouge
    end
  end

  def abbreviations_copied_file_path
    @abbreviations_copied_file_path ||= begin
      File.join(File.dirname(TREE_TAGGER_ABBREVIATES),'french-abbreviations-ORIGINAL')
    end
  end
end #/<< self
end #/Proximite
