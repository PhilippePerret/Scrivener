# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # Méthode appelée lors de la "défaultisation" des options, pour charger
  # le module de construction des textes en fonction du format de sortie.
  # Par exemple, si le format (:output_format) est :text, on va inclure le
  # module .../Output/modules/text.rb qui contient toutes les méthodes de
  # formatage pour le format texte.
  def load_output_modules
    extend Object.const_get('TextAnalyzerOutputHelpersFormat%s' % [options[:output_format].to_s.upcase])
  end
end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
