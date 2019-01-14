# encoding: UTF-8
=begin
  Méthodes de classe de TextAnalyzer::Analyse

=end
class TextAnalyzer
class Analyse
class << self

  # Pour recharger une analyse
  def reload analyse
    File.exist?(analyse.data_path) || rt('files.errors.unfound_file', {pth: analyse.data_path})
    File.stat(analyse.data_path).size > 0 || begin
      debug "--> réanalyse nécessaire (fichier vide: #{analyse.data_path})"
      File.unlink(analyse.data_path)
      analyse.exec
      return analyse
    end
    puts "--> pas d'exécution nécessaire dans reload"
    new_analyse = read_from_file(analyse.data_path, marshal: true)
    puts "-- new_analyse: #{new_analyse.inspect.to_yaml}"
    new_analyse.reload # pour les tables, segments, etc.
    puts "-- new_analyse.table_resultats.methods: #{new_analyse.table_resultats.methods}"
    puts "-- proximites: #{new_analyse.table_resultats.proximites.inspect.to_yaml}"
    return new_analyse
  end

end #/<< self
end #/Analyse
end #/TextAnalyzer
