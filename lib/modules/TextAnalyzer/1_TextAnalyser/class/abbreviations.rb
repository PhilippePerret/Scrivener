class Proximite
class << self

  def open_file_abbreviations
    if File.exist?(TREE_TAGGER_ABBREVIATES)
      backup_original_abbreviations unless backup_abbreviations_exist?
      wt('treetagger.warnings.abbreviations_file_sensible', nil, {color: :bleu})
      yesOrNo(t('files.questions.open_it')) && system('vim "%s"' % TREE_TAGGER_ABBREVIATES)
    else
      rt('treetagger.errors.abbrevations_file_unfound')
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
      wt('treetagger.notices.abbreviations_file_restored', nil, {color: :bleu})
    else
      wt('treetagger.notices.no_abbreviations_file', nil, {color: :rouge})
      puts .rouge
    end
  end

  def abbreviations_copied_file_path
    @abbreviations_copied_file_path ||= begin
      File.join(File.dirname(TREE_TAGGER_ABBREVIATES),'treetagger-abbreviations-ORIGINAL')
    end
  end
end #/<< self
end #/Proximite
