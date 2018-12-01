class Proximite

  # DEL_IN  = "«««\n"
  # DEL_OUT = "\n»»»"

  DEL_IN  = "#{'"'*70}\n\n".freeze
  DEL_OUT = " […]\n\n#{'"'*70}\n".freeze

  METHOD_TRUNCATE = CLI.options[:justify] ? :truncate_and_justify : :truncate

  LENGTH_AUDELA_EXTRAIT = 80

  # Nouvel façon de rendre l'extrait, à partir des segments du projet
  def extrait options = nil
    options ||= Hash.new
    arr = Array.new
    arr << ["--- Document : #{mot_avant.binder_item.title} [#{mot_avant.offset_in_document}]", {style: :gris, col: 6}]

    # On remonte autant de segments qu'il faut pour obtenir la longueur voulue
    len = 0
    ipr = mot_avant.index - 0
    avant_mot_avant = Array.new
    begin
      ipr -= 1
      seg = project.segments[ipr][:seg]
      avant_mot_avant  << seg
      len += seg.length
    end while ipr > 0 && len < LENGTH_AUDELA_EXTRAIT

    avant_mot_avant.reverse!
    avant_mot_avant.empty? || arr << [truncate(avant_mot_avant.join(''))]

    # On doit prendre le texte entre les deux mots
    # Pour le moment, je prends tout, on découpera ensuite si c'est trop long
    texte_between = Array.new
    index_current = mot_avant.index + 0
    begin
      index_current += 1
      texte_between << project.segments[index_current][:seg]
    end while index_current + 1 < mot_apres.index

    # On peut afficher le mot avant
    arr << [mot_avant.real, {style: :exergue_vert, norc: true}]


    texte_between.empty? || arr << [truncate(texte_between.join('')), {norc: true}]

    norc = true
    unless in_same_file?
      arr << [ "--- document : #{mot_apres.binder_item.title} [#{mot_apres.offset_in_document}]\n", {style: :gris, col: 6}]
      # arr << [truncate(extrait_before_mot_apres(3000))]
      norc = false
    end

    # Et enfin le texte après
    ipr = mot_apres.index + 0
    fin_extrait = Array.new
    len = 0
    begin
      dsegment = project.segments[ipr += 1]
      dsegment || break
      fin_extrait << dsegment[:seg]
      len += dsegment[:seg].length
      # ipr += 1
    end while len < LENGTH_AUDELA_EXTRAIT

    # On peut afficher le mot après
    arr << [mot_apres.real, {style: :exergue_rouge, norc: norc}]
    fin_extrait.empty? || arr << [truncate(fin_extrait.join('')), {norc: true}]

    return arr
  end

  # # Extrait affiché dans la fenêtre
  # # L'extrait est composé de :
  # #   - Ligne contenant le nom du document du mot avant
  # def extrait options = nil
  #   options ||= Hash.new
  #   arr = Array.new
  #   arr << ["--- Document : #{mot_avant.binder_item.title} [#{mot_avant.offset_in_document}]", {style: :gris, col: 6}]
  #   arr << [truncate(extrait_before_mot_avant(LENGTH_AUDELA_EXTRAIT))]
  #   arr << [mot_avant.real, {style: :bleu}]
  #   arr << [truncate(extrait_after_mot_avant(1500))]
  #   unless in_same_file?
  #     arr << [ "--- document : #{mot_apres.binder_item.title} [#{mot_apres.offset_in_document}]\n", {style: :gris, col: 6}]
  #     arr << [truncate(extrait_before_mot_apres(3000))]
  #   end
  #   arr << [mot_apres.real, {style: :rouge}]
  #   arr << [truncate(extrait_after_mot_apres(LENGTH_AUDELA_EXTRAIT))]
  #   return arr
  # end


  # Ma propre méthode
  def truncate str
    @max_len ||= Curses.cols > 90 ? 80 : (Curses.cols - 10)
    String.send(METHOD_TRUNCATE, str, @max_len).join(String::RC)
  end

  def line_with_words_and_distance
    # "#{mot_avant.real} [#{mot_avant.offset}] <-- #{human_distance} --> #{mot_apres.real} [#{mot_apres.offset}]"
    "#{mot_avant.real} [#{mot_avant.offset}] <-- #{distance} --> #{mot_apres.real} [#{mot_apres.offset}]"
  end

  # Ajoute une couleur à la distance en fonction de l'éloignement
  def human_distance
    @human_distance ||= begin
      distance.to_s.send(distance_color)
    end
  end

  # Retourne la couleur (méthode) en fonction de la distance séparant
  # les mots.
  def distance_color
    @distance_color ||= begin
      case true
      when distance < 100   then :rouge
      when distance < 500   then :rouge_clair
      when distance < 1000  then :mauve
      else :vert
      end
    end
  end

  def extrait_before_mot_avant(dist)
    if mot_avant.offset_in_document > 0
      s = mot_avant.texte_before(dist).lstrip
      if mot_avant.offset_in_document - dist > 0
        s.prepend('[...] ')
      end
      s
    else
      ''
    end
  end
  # L'extrait
  def extrait_after_mot_avant(dist)
    # Si +dist+ est supérieur à la distance entre les deux mots, on la
    # réduit. Mais quid si les deux mots sont dans deux fichiers différents ?
    dist < distance || dist = distance - mot_apres.length - 1
    mot_avant.texte_after(dist)
  end
  def extrait_before_mot_apres(dist)
    if mot_apres.offset_in_document > 0
      s = mot_apres.texte_before(dist).lstrip
      if mot_apres.offset_in_document - dist > 0
        s.prepend('[...] ')
      end
      s
    else
      ''
    end
  end
  def extrait_after_mot_apres(dist)
    mot_apres.texte_after(dist) + ' [...]'
  end


end #/Proximite
