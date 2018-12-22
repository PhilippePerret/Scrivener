# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class TableResultats
class Output

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
    when :mots_count, :count
      list.sort_by{|icanon| - icanon.mots.count}
    when :proximites_count, :prox_count
      list.reject{|c| c.proximites.empty?}.sort_by{|c| - c.proximites.count}
    else
      list.sort_by{|icanon| icanon.mots.first.sortish}
    end
  end

  def sorted_list_mots
    list = data.mots
    case options[:sorted_by]
    when :count, :occurences
      list.sort_by { |mot_min, index_list| - index_list.count }
    else
      list.sort_by { |mot_min, index_list| analyse.mot(mot_min).sortish }
      # list.sort_by { |mot_min, index_list| analyse.texte_entier.mot(index_list.first).sortish }
    end
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES DE LISTING DES ÉLÉMENTS


  # Affichage/sortie des canons
  def canons opts = nil
    defaultize_options(opts)
    footer_line = nil
    nombre_canons_affiched = 0
    sorted_list_canons.each_with_index do |icanon, index|
      index > 0 || begin
        ecrit(icanon.header(options))
        footer_line = icanon.footer
      end
      ecrit icanon.as_line_output(index)
      nombre_canons_affiched += 1
      nombre_canons_affiched < options[:limit] || break
    end
    ecrit footer_line
  end
  # /canons

  # Affichage/sortie des proximités
  def proximites opts = nil
    defaultize_options(opts)
    footer_line = nil
    nombre_proximites_affiched = 0
    sorted_list_proximites.each_with_index do |iprox, index|
      index > 0 || begin
        ecrit(iprox.header(options))
        footer_line = iprox.footer_line
      end
      ecrit iprox.as_line_output(index + 1)
      nombre_proximites_affiched += 1
      nombre_proximites_affiched < options[:limit] || break
    end
    ecrit footer_line
  end

  # Affichage / sortie des mots (de tous les mots du texte, il est donc
  # préférable d'indiquer une limite)
  def mots opts = nil
    defaultize_options(opts)
    footer_line           = nil
    nombre_mots_affiched  = 0
    sorted_list_mots.each_with_index do |dmot, index|
      # ATTENTION : l'index dont il est question ici n'a rien à voir avec
      # l'index réel du mot dans le texte.
      imot = analyse.texte_entier.mot(dmot[1][0])
      index > 0 || begin
        ecrit(imot.header(options))
        footer_line = imot.footer_line
      end
      imot.length > 2 || next
      ecrit imot.as_line_output(nombre_mots_affiched + 1)
      nombre_mots_affiched += 1
      nombre_mots_affiched < options[:limit_mots] || break
    end
    ecrit footer_line
  end
  # /mots

end #/Output
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
