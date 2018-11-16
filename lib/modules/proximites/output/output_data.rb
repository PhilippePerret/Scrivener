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

  # = main =
  #
  # Méthode appelée lorsque l'on utilise l'option --data avec `scriv prox`
  #
  LINETBL_LABEL_WITDH = 30
  LINETBL_VALUE_WIDTH = 10
  TAB = '  '
  RC  = String::RC

  attr_accessor :tableau_resultat

  def build_tableau_resultat_proximites
    # On récupère les données de proximité, ou on les calcul.
    get_data_proximites
    tableau = self.tableau_proximites

    separation = '_' * 80 + RC * 2

    self.tableau_resultat = Array.new

    tableau_resultat << RC*3
    # puts "\n\n\n"
    tableau_resultat << separation
    # puts separation

    # On boucle sur tous les mots pour :
    #   1. Connaitre les plus grandes fréquences
    #   2. Connaitre le nombre de mots qui ont une trop grande proximités
    mots_with_proximites = Array.new
    mots_sans_proximites = Array.new
    mots_sorted_by_prox =
      tableau[:mots].sort_by do |canon, dcanon|
        if dcanon[:proximites].empty?
          mots_sans_proximites << canon
        else
          mots_with_proximites << canon
        end
        - dcanon[:proximites].count
      end

    line_title = "TITRE : #{File.basename(self.path)}"
    tableau_resultat << TAB + line_title
    tableau_resultat << TAB + ('-' * line_title.length) + (RC * 2)
    plinetbl('Longueur du texte (signes)', longueur_whole_texte)
    plinetbl('      => Nombre pages', (longueur_whole_texte / String::PAGE_WIDTH).round + 1)
    plinetbl('Nombre total de mots', segments.count / 2)
    plinetbl('      => Nombre pages', ((segments.count / 2) / String::NOMBRE_MOTS_PAGE).round + 1)
    plinetbl('Nombre de mots canoniques', tableau[:mots].count)
    nombre_mots_avec_proximites = mots_with_proximites.count
    plinetbl('Nombre de mots avec proximités', nombre_mots_avec_proximites)
    plinetbl('Nombre de mots sans proximités', mots_sans_proximites.count)
    plinetbl('Nombre de proximités', tableau[:proximites].count)
    if nombre_mots_avec_proximites > 0
      max = nombre_mots_avec_proximites > 10 ? 10 : nombre_mots_avec_proximites
      tableau_resultat << TAB+"Les #{max} mots à plus forte proximité"
      mots_sorted_by_prox[0...max].each do |canon, dcanon|
        plinetbl('        - %s' % canon, dcanon[:proximites].count)
      end
    else
      tableau_resultat << TAB+'Formidable ! Ce texte ne comporte aucune proximité.'
    end

    # Construction du tableau montrant la densité des proximités
    build_tableau_densite

    tableau_resultat << separation
    tableau_resultat << RC*3

    # Pour afficher le tableau, on le met 20 lignes par 20 lignes
    until (portion = tableau_resultat.shift(5)).empty?
      puts portion.join(RC)
      sleep 0.2
    end
    # puts tableau_resultat.join(RC)

  end

  def longueur_whole_texte
    @longueur_whole_texte ||= File.stat(whole_text_path).size
  end

  # Pour dessiner le tableau des densités, qui représente la densité de proximités
  # en fonction de l'endroit du livre. On part du principe qu'on fait x colonnes,
  # d'une taille définie en caractères en fonction de la longueur du texte. Au minimum,
  # on obtient 10 colonnes, au maximum, on en obtient 50.
  # Ce nombre de colonnes, en fonction de la longueur, définit un nombre de caractères
  # par colonne. On affiche ensuite le nombre de proximité (%) par colonne.
  def build_tableau_densite
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
      tableau_proximites[:proximites].each do |prox_id, iprox|
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
    tableau_resultat << RC*3
    tit = "Tableau des densités de proximités"
    tableau_resultat <<  TAB + tit
    tableau_resultat <<  TAB + '-'*tit.length
    tableau_resultat <<  RC*2
    (0..15).each do |i|
      h = 15 - i
      linei = TAB+''
      colonnes.each do |icol, valcol|
        linei << (valcol >= h ? '∎' : ' ')
        # linei << (valcol >= h ? '𐄲' : ' ')
        # linei << (valcol >= h ? '𐄗' : ' ')
        # linei << (valcol >= h ? '☐' : ' ')
        # linei << (valcol >= h ? '◻︎' : ' ')
      end
      tableau_resultat << linei
    end
    col_count = colonnes.count
    tableau_resultat << TAB + '–' * col_count
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
    tableau_resultat << [line1,line10,line100,line1000].join(' ' + RC)
    tableau_resultat << RC*3
  end
  # /dessiner_tableau_densite

  def plinetbl label, value
    tableau_resultat << TAB+'%s : %s' % [label.ljust(LINETBL_LABEL_WITDH), value.to_s.rjust(LINETBL_VALUE_WIDTH)]
  end

  def output_data_proximites
    get_data_proximites || return
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
