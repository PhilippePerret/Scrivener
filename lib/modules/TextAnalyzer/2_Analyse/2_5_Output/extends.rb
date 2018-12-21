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
    require '%s/lib/modules/modules_output_by_type/%s.rb' % [APPFOLDER, options[:output_format]]
    extend TextAnalyzerOutputHelpers
  end
end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
