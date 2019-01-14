# encoding: UTF-8
=begin
  Module pour les méthodes d'entrée/sortie des résultats, c'est-à-dire
  d'écriture et de lecture des données enregistrées.
=end
class TextAnalyzer
class Analyse
class TableResultats
class << self

  # Méthode qui retourne la table des résultats prise dans le fichier marshal
  # (rechargement)
  def load(analyse)
    analyse.table_resultats.exist? || rt('textanalyzer.errors.no_table_resultats')
    tr = read_from_file(analyse.table_resultats.file_path, {marshal: true})
    # puts "-- tr: #{tr.inspect}"
    return tr
  end

end #/<< self
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
