class Symbol

  # Transforme :include_in_selection en IncludeInSelection
  def camelize
    self.to_s.split('_').collect{|w|w.capitalize}.join('')
  end
end #/Symbol
