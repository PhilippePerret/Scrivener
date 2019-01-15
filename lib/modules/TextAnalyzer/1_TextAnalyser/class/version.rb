# encoding: UTF-8
class TextAnalyzer
  def self.current_version
    File.read(Scrivener.fpath('TEXTANALYZER_VERSION')).strip
  end
end #/TextAnalyzer
