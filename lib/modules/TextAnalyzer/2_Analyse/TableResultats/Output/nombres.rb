# encoding: UTF-8
=begin
  Pour sortir les résultats numéraires
=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # Pour sortir tous les nombres
  def nombres opts = nil
    defaultize_options(opts)

    case options[:output]
    when :cli
      puts "Nombre de mots         : #{data.mots.count}"
      puts "Nombre de mots uniques : #{data.nombre_mots_uniques}"
    when :file
    end
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
