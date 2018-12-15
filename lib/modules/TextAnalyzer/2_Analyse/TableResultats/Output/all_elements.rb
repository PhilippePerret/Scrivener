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
  def sorted_list_by_options list, type
    case type
    when :proximites
      case options[:sorted_by]
      when :distance
        list.values.sort_by{|iprox| iprox.distance}
      else # :alpha et autres
        list.values.sort_by{|iprox| iprox.mot_avant.real[0..4].downcase.normalize}
      end
    when :canons
      case options[:sorted_by]
      when :alpha
        list.sort_by{|icanon| icanon.canon.real[0..4].downcase.normalize}
      when :mots_count
        list.sort_by{|icanon| - icanon.mots.count}
      when :proximites_count
        list.reject{|c| c.proximites.empty?}.sort_by{|c| - c.proximites.count}
      end
    end
  end
  # /sorted_list_by_options

  # ---------------------------------------------------------------------
  #   MÉTHODES DE LISTING DES ÉLÉMENTS
  
  # Affichage/sortie des mots
  def mots opts = nil
    defaultize_options(opts)
    puts Mot::LINE_MOT_ENTETE
    data.mots.each_with_index do |mot, index|
      puts "mot #{index}: #{mot}"
    end
  end
  # /mots

  def liste_mots_uniques opts = nil
    defaultize_options(opts)
    data.liste_mots_uniques.each_with_index do |mot, index_mot|
      puts "mot unique #{index_mot.to_s.ljust(3)}: #{mot[0]}"
    end
  end
  # /liste_mots_uniques


  # Affichage/sortie des canons
  def canons opts = nil
    defaultize_options(opts)
    sorted_list_by_options(data.canons.values, :canons).each_with_index do |icanon, index|
      index > 0 || puts(icanon.header(options))
      puts icanon.as_line_output(index)
    end
    # data.canons.values.each_with_index do |icanon, index|
    #   puts icanon.as_line_output(index)
    # end
  end
  # /canons

  # Affichage/sortie des proximités
  def proximites opts = nil
    defaultize_options(opts)
    options.merge!(sorted_by: :alpha)
    puts Proximite::LINE_PROXIMITE_ENTETE
    sorted_list_by_options(data.proximites, :proximites).each_with_index do |iprox, index|
      puts iprox.as_line_output(index + 1)
    end
    # data.proximites.each do |prox_id, iprox|
    #   puts iprox.as_line_output(index += 1)
    # end
  end


end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
