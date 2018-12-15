# encoding: UTF-8
=begin
  Module des méthodes gérant la sortie des proximités
=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  def proximites opts = nil
    defaultize_options(opts)
    # TODO Utiliser quelque chose comme sorted_list_by_options(liste) pour
    # travailler avec une liste classée selon les options. Par exemple classée
    # par nombre d'occurences, par ordre alphabétique, etc. C'est la propriété
    # sorted_by: des options qui peut définir :alpha, :count ou une autre
    # méthode qui permettra de classer les éléments. :sorted_reverse pourrait
    # permettre de classer dans l'ordre inverse.
    data.proximites.each do |prox_id, iprox|
      puts iprox.as_line_resultat
    end
  end

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
