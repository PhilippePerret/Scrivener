class TextAnalyzer
class Analyse
class WholeText
class Mot

  # Redéfinition
  def inspect
    return '<<AnalyzedFile::Text::Mot(my inspect) @index=%i @offset=%i @real=%s @object_id_file=%s, @proximite_avant_id=%s @proximite_apres_id=%s @length=%i>>' %
      [self.index, self.offset, self.real, self.object_id_file,
      self.proximite_avant_id.inspect, self.proximite_apres_id.inspect, self.length]
  end

  def reset
    self.real   = nil
    [:downcase, :canonique, :length, :is_treatable, :is_real_mot, :distance_minimale
    ].each do |prop|
      self.instance_variable_set("@#{prop}", nil)
    end
  end

end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
