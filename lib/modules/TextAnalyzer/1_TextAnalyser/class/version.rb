# encoding: UTF-8
class TextAnalyzer
class << self
  def current_version
    File.read(Scrivener.fpath('TEXTANALYZER_VERSION')).strip
  end
  alias :version :current_version
end #/<< self
end #/TextAnalyzer
