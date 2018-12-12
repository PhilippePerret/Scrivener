class TextAnalyzer
class Analyse
class WholeText
class Mot

  # {String} Le mot fourni à l'instanciation et le mot initial gardé,
  # même si :real_mot est transformé.
  attr_accessor :real, :real_init

  # {Fixnum} ObjectID du fichier (TextAnalyzer::File) auquel appartient
  # le mot
  attr_accessor :file_id

  # {Fixnum} Index du mot dans le texte complet
  attr_accessor :index

  # {Fixnum} Décalage du mot dans le texte (attention : le texte complet,
  # pas le texte du fichier :file).
  attr_accessor :offset

  # {Fixnum} Décalage du mot dans le texte de son fichier
  attr_accessor :relative_offset

  # raccourci pour obtenir l'analyse à laquelle appartient le mot
  def analyse ; @analyse ||= file.analyse end
  def file
    @file ||= TextAnalyzer::AnalyzedFile.get(file_id)
  end

  def downcase
    @downcase ||= real.downcase
  end

  # Forme canonique du mot (lemmatisé). Par exemple, "marcherions" aura
  # comme forme canonique "marcher"
  def canon
    @canon ||= (TABLE_LEMMATISATION[downcase] || real).downcase
  end
  alias :canonique :canon

  def length
    @length ||= real.length
  end

  def proximite_avant
    @proximite_avant ||= begin
      analyse.table_resultats.proximites[proximite_avant_id]
    end
  end
  def proximite_apres
    @proximite_apres ||= begin
      analyse.table_resultats.proximites[proximite_apres_id]
    end
  end

  def distance_minimale
    @distance_minimale ||= self.class.distance_minimale(canonique)
  end


end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
