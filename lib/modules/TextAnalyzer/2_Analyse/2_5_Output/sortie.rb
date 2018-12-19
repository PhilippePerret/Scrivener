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
    # = Proxmités =
    proximites(sorted_by: :distance, limit: 50)
    proximites(sorted_by: :alpha, limit: 50)
    # = Canons =
    canons(sorted_by: :alpha, limit: 50)
    canons(sorted_by: :prox_count, limit: 50)
    canons(sorted_by: :mots_count, limit: 50)
    # = Mots =
    CLI.debug_exit
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
