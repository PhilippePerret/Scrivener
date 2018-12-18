=begin
  Pour sortir le résultat en console

  0
  31
  42
  43

  Marion devrait être à 51 et c'est 45
=end
class Scrivener
class Project


  # Pour dessiner le tableau des densités, qui représente la densité de proximités
  # en fonction de l'endroit du livre. On part du principe qu'on fait x colonnes,
  # d'une taille définie en caractères en fonction de la longueur du texte. Au minimum,
  # on obtient 10 colonnes, au maximum, on en obtient 50.
  # Ce nombre de colonnes, en fonction de la longueur, définit un nombre de caractères
  # par colonne. On affiche ensuite le nombre de proximité (%) par colonne.
  #
  # RETURN {String} LE GRAPH DES DENSITÉS
  #
  def build_graph_densites
    # Détermination du nombre de colonnes
    if longueur_whole_texte < 500
      # Inutile de faire un tableau de densité
      return
    elsif longueur_whole_texte < 5000
      nombre_colonnes = 10
    elsif longueur_whole_texte < 50000
      nombre_colonnes = 25
    elsif longueur_whole_texte < 200000
      nombre_colonnes = 50
    else
      nombre_colonnes = 80
    end
    largeur_colonne = longueur_whole_texte / nombre_colonnes

    colonnes = Hash.new
    (0...nombre_colonnes).each do |icolonne|
      analyse.table_resultats.proximites.each do |prox_id, iprox|
        offset_mavant = iprox.mot_avant.offset
        offset_mapres = iprox.mot_apres.offset
        colonne_mavant = offset_mavant / largeur_colonne
        colonne_mapres = offset_mapres / largeur_colonne
        (colonne_mavant..colonne_mapres).each do |icol|
          colonnes.key?(icol) || colonnes.merge!(icol => 0)
          colonnes[icol] += 1
        end
      end
    end

    # Il faut maintenant transformer les nombres en pourcentage,
    # en sachant que la hauteur max est de 15 lignes.
    # On doit donc chercher le nombre maximum pour savoir l'indice
    # à appliquer sur les colonnes.
    max_prox    = colonnes.map{|icol,nb| nb}.max
    max_height  = 15
    height_coef = max_height.to_f / max_prox
    # Pour faire height * coef => hauteur sur 15 max

    # On transforme les valeurs de toutes les colonnes
    colonnes.each do |icol, valcol|
      colonnes[icol] = (valcol * height_coef).round
    end

    # puts "--- colonnes: #{colonnes.inspect}"

    # On trame sur chaque ligne. Si une colonne a une
    # valeur égale ou supérieure à la ligne, on met un "bloc"
    #
    graph = Array.new
    graph << RC * 3
    tit = "Tableau des densités de proximités"
    graph <<  TAB + tit
    graph <<  TAB + '-'*tit.length
    graph <<  RC * 2
    (0..15).each do |i|
      h = 15 - i
      linei = TAB+''
      colonnes.each do |icol, valcol|
        linei << (valcol >= h ? '∎' : ' ')
      end
      graph << linei
    end
    col_count = colonnes.count
    graph << TAB + '–' * col_count
    # Une colonne sur deux on va mettre le nombre de pages
    line1000  = TAB+''
    line100   = TAB+''
    line10    = TAB+''
    line1     = TAB+''
    (0...col_count).step(2).each do |icol|
      nb_chars    = icol * largeur_colonne
      nb_pages    = (nb_chars / 1500) + 1
      rev_pages   = nb_pages.to_s
      if nb_pages > 999
        line1     << String::CHIFFRE_BAS[rev_pages[0].to_i]
        line10    << String::CHIFFRE_HAUT[rev_pages[1].to_i]
        line100   << String::CHIFFRE_BAS[rev_pages[2].to_i]
        line1000  << String::CHIFFRE_HAUT[rev_pages[3].to_i]
      elsif nb_pages > 99
        line1     << String::CHIFFRE_BAS[rev_pages[0].to_i]
        line10    << String::CHIFFRE_HAUT[rev_pages[1].to_i]
        line100   << String::CHIFFRE_BAS[rev_pages[2].to_i]
        line1000  << ' '
      elsif nb_pages > 9
        line1     << String::CHIFFRE_BAS[rev_pages[0].to_i]
        line10    << String::CHIFFRE_HAUT[rev_pages[1].to_i]
        line100   << ' '
        line1000  << ' '
      else
        line1     << String::CHIFFRE_BAS[rev_pages[0].to_i]
        line10    << ' '
        line100   << ' '
        line1000  << ' '
      end
      line1 << ' '
      line10 << ' '
      line100 << ' '
      line1000 << ' '
    end
    [line10, line100, line100, line1000].each do |line|
      if line[2..14].strip == ''
        line[2..14] = '𝑛𝑢𝑚𝑒𝑟𝑜𝑠 𝑝𝑎𝑔𝑒𝑠'
        break
      end
    end
    graph << [line1,line10,line100,line1000].join(' ' + RC)
    graph << RC*3

    return graph.join(RC)
  end
  # /dessiner_tableau_densite

  def output_data_proximites
    get_data_analyse || return
    puts "\n\n==== DATA DE PROXIMITES ==="
    # puts tableau_proximites.inspect

    tableau_proximites[:mots].each do |mot_canonique, data_mot|
      puts "--- mot générique : #{mot_canonique}"
      data_mot[:items].each do |imot|
        puts "   - #{imot.real} :: #{imot.offset}"
      end
    end
  end

end #/Project
end #/Scriver
