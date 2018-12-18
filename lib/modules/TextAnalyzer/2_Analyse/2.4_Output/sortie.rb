# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # = main =
  # Méthode principale qui sort tous les
  def all opts = nil
    CLI.debug_entry
    defaultize_options(opts)
    table_nombres
    CLI.debug_exit
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
