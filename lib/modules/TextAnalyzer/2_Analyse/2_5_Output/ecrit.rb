# encoding: UTF-8
=begin
  Module des méthodes permettant l'écriture du résultat en fonction de la
  sortie choisie
=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  def ecrit str
    case options[:output]
    when :text, :cli
      puts str
    else
      raise 'La sortie de format `%s` n’est pas encore implémentée.' % options[:output]
    end
  end
end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
