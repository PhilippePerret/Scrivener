# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data

  def exist?
    File.exist?(path)
  end

  def save
    self.text_analyzer_version = TextAnalyzer.current_version
    File.open(path,'wb').write(Marshal.dump(self))
  end

  def path
    @path ||= File.join(analyse.hidden_folder,'data.msh')
  end

end #/Data
end #/Analyse
end #/TextAnalyzer
