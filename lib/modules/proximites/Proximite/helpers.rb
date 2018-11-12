class Proximite

  # DEL_IN  = "«««\n"
  # DEL_OUT = "\n»»»"

  DEL_IN  = "#{'"'*70}\n\n".freeze
  DEL_OUT = " […]\n\n#{'"'*70}\n".freeze

  METHOD_TRUNCATE = CLI.options[:justify] ? :truncate_and_justify : :truncate

  LENGTH_AUDELA_EXTRAIT = 80

  # Extrait affiché dans la fenêtre
  # L'extrait est composé de :
  #   - Ligne contenant le nom du document du mot avant
  def extrait options = nil
    options ||= Hash.new
    arr = Array.new
    arr << ["--- Document : #{mot_avant.binder_item.title} [#{mot_avant.offset_in_document}]", {style: :gris, col: 6}]
    arr << [truncate(extrait_before_mot_avant(LENGTH_AUDELA_EXTRAIT))]
    arr << [mot_avant.real, {style: :bleu}]
    arr << [truncate(extrait_after_mot_avant(1500))]
    unless in_same_file?
      arr << [ "--- document : #{mot_apres.binder_item.title} [#{mot_apres.offset_in_document}]\n", {style: :gris, col: 6}]
      arr << [truncate(extrait_before_mot_apres(3000))]
    end
    arr << [mot_apres.real, {style: :rouge}]
    arr << [truncate(extrait_after_mot_apres(LENGTH_AUDELA_EXTRAIT))]
    return arr
  end


  # Ma propre méthode
  def truncate str
    String.send(METHOD_TRUNCATE, str, 80).join(String::RC)
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
