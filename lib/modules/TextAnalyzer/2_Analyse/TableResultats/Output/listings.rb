# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

  # Méthode utilisée par toutes les méthodes suivantes pour classer la liste
  # +list+ en fonction de son type +type+ et en fonction des options d'affichage
  # déterminées.
  def sorted_list_by_options type
    case type
    when :proximites
      sorted_list_proximites_by_options
    when :canons
      sorted_list_canons
    end
  end
  # /sorted_list_by_options
  def sorted_list_proximites
    list = data.proximites.values
    case options[:sorted_by]
    when :distance
      list.sort_by{|iprox| iprox.distance}
    else # :alpha et autres
      list.sort_by{|iprox| iprox.mot_avant.real[0..4].downcase.normalize}
    end
  end
  def sorted_list_canons
    list = data.canons.values
    case options[:sorted_by]
    when :alpha
      list.sort_by{|icanon| icanon.canon.real[0..4].downcase.normalize}
    when :mots_count
      list.sort_by{|icanon| - icanon.mots.count}
    when :proximites_count
      list.reject{|c| c.proximites.empty?}.sort_by{|c| - c.proximites.count}
    end
  end
  def sorted_list_mots
    list = data.mots.values
    case options[:sorted_by]
    when :count
    else
      list.sort_by { |mot| mot.sortish }
    end
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES DE LISTING DES ÉLÉMENTS


  # Affichage/sortie des canons
  def canons opts = nil
    defaultize_options(opts)
    sorted_list_canons.each_with_index do |icanon, index|
      index > 0 || puts(icanon.header(options))
      ecrit icanon.as_line_output(index)
    end
    # data.canons.values.each_with_index do |icanon, index|
    #   puts icanon.as_line_output(index)
    # end
  end
  # /canons

  # Affichage/sortie des proximités
  def proximites opts = nil
    defaultize_options(opts)
    sorted_list_proximites.each_with_index do |iprox, index|
      index > 0 || puts(iprox.header(options))
      ecrit iprox.as_line_output(index + 1)
    end
  end

  # Affichage/sortie des mots
  def mots opts = nil
    defaultize_options(opts)
    sorted_list_mots.each_with_index do |imot, index|
      index > 0 || puts(imot.header(options))
      ecrit imot.as_line_output(index + 1)
    end
  end
  # /mots

  def liste_mots_uniques opts = nil
    defaultize_options(opts)
    data.liste_mots_uniques.each_with_index do |mot, index_mot|
      ecrit "mot unique #{index_mot.to_s.ljust(3)}: #{mot[0]}"
    end
  end
  # /liste_mots_uniques


end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer