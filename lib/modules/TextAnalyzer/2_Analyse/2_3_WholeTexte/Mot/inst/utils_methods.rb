class TextAnalyzer
class Analyse
class WholeText
class Mot

  # Redéfinition pour lecture plus facile
  def inspect
    return '<<TA::AN::WT::Mot(my inspect) @index=%{index} @real=%{real} @lemma=%{lemma} @canon=%{canon}>>' % self.data
  end

  def data
    @data ||= begin
      h = Hash.new
      properties.each { |p| h.merge!(p => instance_variable_get("@#{p}")) }
      h
    end
  end
  def properties
    @properties ||= [:real, :index, :offset, :file_id, :length, :canon, :lemma]
  end

  def volatile_properties
    @volatile_properties ||= [:downcase, :is_treatable, :is_real_mot, :distance_minimale]
  end

  # TODO Il faut peut-être revoir cette propriété et pouvoir de reseter que
  # les propriétés volatiles. Normalement, les autres ne devraient pas bouger
  def reset
    self.real   = nil
    [:downcase, :canon, :length, :is_treatable, :is_real_mot, :distance_minimale
    ].each do |prop|
      self.instance_variable_set("@#{prop}", nil)
    end
  end

end #/Mot
end #/WholeText
end #/Analyse
end #/TextAnalyzer
