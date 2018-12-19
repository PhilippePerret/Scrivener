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
    File.open(path,'wb').write(Marshal.dump(self))
  end

  # ATTENTION : ça charge l'instance elle-même, donc en fait : il faut
  # instancier un objet Data, puis appeler la méthode load pour définir la
  # variable qui contiendra vraiment les données (l'instance retournée)
  def load
    File.open(path,'rb'){|f|Marshal.load(f)}
  end

  def path
    @path ||= File.join(analyse.hidden_folder,'data.msh')
  end

end #/Data
end #/Analyse
end #/TextAnalyzer
