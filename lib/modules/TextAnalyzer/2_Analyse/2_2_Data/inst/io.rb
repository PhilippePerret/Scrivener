# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data

  def save
    File.open(path,'wb').write(Marshal.dump(self))
  end

  def load
    File.open(path,'rb'){|f|Marshal.load(f)}
  end

  def path
    @path ||= File.join(analyse.hidden_folder,'data.msh')
  end

end #/Data
end #/Analyse
end #/TextAnalyzer
