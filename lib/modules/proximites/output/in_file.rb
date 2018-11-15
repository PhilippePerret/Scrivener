=begin

  Module principal qui va construire les fichiers RTF pour scrivener avec
  indication des proximités en couleur
=end
class Scrivener
class Project

  include Colors

  attr_accessor :array_colors_rtf

  # = main =
  #
  # Cette méthode est appelée quand on joue la commande `scriv prox` avec
  # l'option `--in_file`
  def build_proximites_scrivener_file

    # Dans un premier temps, il faut s'assurer que le projet ne soit pas
    # ouvert dans Scrivener. On pourrait le faire par AppleScrit, mais je
    # préfère demander à l'utilisateur.
    yesOrNo('Le projet est-il bien fermé dans Scrivener ? C’est indispensable.', {invite: 'Projet fermé'}) || return

    # # Pour faire des essais
    # puts (project.folders.title).inspect
    # puts project.folders.exist?(title: 'Recherche')
    # puts project.folders.exist?(title: 'Ébauche')
    # puts "\n\nJe retourne tout de suite"
    # return

    erase_files_proximites_if_exists

    build_simple_texte_file_with_color_tags

    convert_simple_texte_file

    corrige_color_tags_in_rtf_file

    add_colors_definition_in_header

    File.unlink(file_txt_with_colortags_path)

    folder_bitem = project.folders.find(title: 'Proximités')
    folder_bitem ||= build_folder_proximites_in_scrivener

    file_bitem = build_file_proximites_in_scrivener(folder_bitem)
    # =>  Le binder-item du fichier, qui contient notamment le UUID qui
    #     va permettre de créer le fichier dans le dossier Data/Files pour
    #     mettre le fichier content.rtf

    # On sauvegarde le fichier scrivx
    project.xfile.save

    # On crée le fichier
    FileUtils.cp file_final_rtf_with_colortags_path, file_bitem.rtf_text_path

    # CLI.options[:open] && `open "#{file_final_rtf_with_colortags_path}"`

  end

  def build_folder_proximites_in_scrivener
    project.create_main_folder({title: 'Proximités', after: :draft_folder})
  end
  # /build_folder_proximites_in_scrivener

  def build_file_proximites_in_scrivener(folder_bitem)
    project.create_binder_item(nil, {
      title: 'Check du %s' % [Time.now.strftime('%d %m %Y - %H:%M')],
      container: folder_bitem.node.attributes['UUID']
    })
  end
  # /build_file_proximites_in_scrivener


  # Pour coloriser les mots
  FULL_MOT_EXERGUE = '\cf1 \cb%{color} %{mot}\cb1 \cf0 '
  SPLIT_MOT_EXERGUE = '\cf1 \cb%{prev_col} %{prev_moitie}\cb%{next_col} %{next_moitie}\cb1 \cf0 '

  # On construit un fichier texte avec chaque proximité colorisé
  def build_simple_texte_file_with_color_tags

    # Pour créer un cycle de couleurs
    color_cycle = Colors::Cycle.new(in: :dark_colors, format: :rtf)

    nombre_couleurs = color_cycle.nombre_couleurs

    # Pour procéder efficacement :
    # On passe en revue toutes les proximités (non écartées ou corrigées),
    # et on ajoute à la donnée segment de leurs deux mots une couleur.
    #
    # Note : on regarde l'offset du mot après pour savoir si un indice de
    # couleur peut à nouveau être utilisé
    #
    i_color = 2
    tableau_proximites[:proximites].each do |prox_id, iprox|

      iprox.erased? || iprox.ignored? || iprox.fixed? && next

      mavant = iprox.mot_avant
      mapres = iprox.mot_apres

      i_color += 1
      if i_color > nombre_couleurs
        i_color = 3
      end

      segments[mavant.index].merge!(next_color: i_color, has_color: true)
      segments[mapres.index].merge!(prev_color: i_color, has_color: true)

    end

    arr_colors = Array.new
    arr_colors << '\red255\green255\blue255'
    arr_colors << '\red0\green0\blue0'
    nombre_couleurs.times { arr_colors << color_cycle.next }
    self.array_colors_rtf = arr_colors

    rf = File.open(file_txt_with_colortags_path, 'ab')
    portion = String.new
    segments.each do |dsegment|
      segment_str =
      if dsegment.delete(:has_color)
        # <=  Une (ou 2) couleur est définie dans le segment, c'est donc qu'un
        #     mot précédent a défini cette proximité. Il suffit de la
        #     prendre
        #     Note : on delete pour ne pas enregistrer la propriété avec
        #     les segments.
        # => On la prend et on l'appliquer
        if dsegment[:prev_color].nil? || dsegment[:next_color].nil?
          # <= Une seule couleur
          # => tout le mot peut être colorisé
          color = dsegment[:prev_color] || dsegment[:next_color]
          FULL_MOT_EXERGUE % {color: color, mot: dsegment[:seg]}
          # Rien après, merci
        else
          # <= Les deux couleurs sont définies
          # => il faut coloriser de deux couleurs le mot
          seglen = dsegment[:seg].length
          moitie = seglen / 2
          prev_moitie = dsegment[:seg][0...moitie]
          next_moitie = dsegment[:seg][moitie..-1]
          SPLIT_MOT_EXERGUE % {
            prev_col:     dsegment[:prev_color],
            prev_moitie:  prev_moitie,
            next_col:     dsegment[:next_color],
            next_moitie:  next_moitie
          }
          # Rien après, merci
        end
      else
        # <= Pas de couleur défini
        # => le mot tel quel
        dsegment[:seg]
        # Rien après, merci
      end
      portion << segment_str
      portion.length < 1000 || begin
        rf.write(portion)
        portion = ''
      end
    end
    # La dernière
    portion == '' || rf.write(portion)
  ensure
    rf && rf.close
  end

  # On convertit le fichier simple en fichier RTF
  def convert_simple_texte_file
    `textutil -convert rtf "#{file_txt_with_colortags_path}"`
  end

  def corrige_color_tags_in_rtf_file
    # TODO Traiter différemment si le fichier est trop volumineux
    # (utiliser File.open(...).each et enregistrer au fur et à mesure)
    code = File.read(file_rtf_with_colortags_path)
    code.gsub!(/\\(\\c[fb][0-9]+ )/, '\1')
    File.open(file_rtf_with_colortags_path,'wb'){|f|f.write code}
  end

  # On ajoute la balise des couleurs dans le fichier RTF
  def add_colors_definition_in_header
    colors_definition = '{\colortbl;%s;}' % [array_colors_rtf.join(';')]

    ffinal = File.open(file_final_rtf_with_colortags_path,'ab')
    not_yet_placed = true
    File.open(file_rtf_with_colortags_path,'rb').each do |line|

      if not_yet_placed && line.start_with?('{\colortbl')
        line = colors_definition + String::RC
        not_yet_placed = false
      end

      ffinal.write(line)

    end

    not_yet_placed && raise('La balise des couleurs n’a pas pu être placée…')

  ensure
    ffinal.close
  end


  def erase_files_proximites_if_exists
    File.unlink(file_txt_with_colortags_path) if File.exists?(file_txt_with_colortags_path)
    File.unlink(file_rtf_with_colortags_path) if File.exists?(file_rtf_with_colortags_path)
    File.unlink(file_final_rtf_with_colortags_path) if File.exists?(file_final_rtf_with_colortags_path)
  end

  def file_txt_with_colortags_path
    @file_txt_with_colortags_path ||= File.join(project.folder, 'with_color_tags.txt')
  end
  def file_final_rtf_with_colortags_path
    @file_final_rtf_with_colortags_path ||= File.join(project.folder, 'with_color_tags-final.rtf')
  end
  def file_rtf_with_colortags_path
    @file_rtf_with_colortags_path ||= File.join(project.folder, 'with_color_tags.rtf')
  end

end #/Project
end #/Scrivener
