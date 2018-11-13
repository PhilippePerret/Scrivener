=begin
  Pour sortir le résultat en console
=end
require 'curses'

class Scrivener
class Project
class Console

  CONSOLE_WIDTH = 70

  SEPARATEURS = {
    guils: nil,
    }

class << self

  attr_accessor :tableau

  # Raccourci pour écrire des messages à l'écran (en bas)
  def msg str, options = nil
    Curses::MessageWindow.message(str, options)
  end
  def clear_msg
    Curses::MessageWindow.message('')
  end

  def output(tableau)
    CLI.dbg("-> Scrivener::Project::Console#output (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

    self.tableau = tableau

    # On prépare l'écran
    Curses.init_screen
    Curses.curs_set(0)  # Curseur invisible
    Curses.start_color
    Curses.noecho

    SEPARATEURS[:guils] = '"'*(Curses.cols - 4)
    SEPARATEURS[:plats] = '–'*(Curses.cols - 4)

    # Initialisation des couleurs customisées
    Curses.init_custom_color # méthode propre à l'extension

    # On prépare les deux parties d'écran

    nombre_lines_windown    = 6
    nombre_lines_winheader  = 3
    nombre_lines_winup      = Curses.lines - (nombre_lines_winheader + nombre_lines_windown + 1)
    top_windown = nombre_lines_winheader + nombre_lines_winup
    # Note : le "+1" de la fin sert à la fenêtre des messages


    # --- Les fenêtres ---
    winheader = Window.new(nombre_lines_winheader, background: Curses::CUSTOM_COLORS[:noir_sur_blanc])
    winup     = Window.new(nombre_lines_winup, top: nombre_lines_winheader, background: Curses::CUSTOM_COLORS[:noir_sur_blanc])
    windown   = Window.new(nombre_lines_windown, top: top_windown)

    Curses.default_message_window = windown.cwindow #méthode propre à l'extension

    begin
      Curses::MessageWindow.create(top: Curses.lines - 1)
      # On prépare les fenêtres
      windown.affiche(panneau_nomenclature)

      # On prépare l'entête pour les données
      prepare_header_up_window(winheader)

    rescue Exception => e
      winup.affiche(e.message)
      winup.affiche(String::RC + e.backtrace.first)
      debug(e)
      sleep 4
    end


    begin
      # Initialisation des pointeurs
      # ----------------------------
      # Rappel : ils sont tous consignés dans la constante POINTEURS. Cf. le
      # module de même nom.
      debug('* Initialisation des pointeurs…')
      init_pointeurs


      # TODO Comment afficher un texte qui tient compte des changements de mots
      # opérés ? En mémorisant tout et en reconstruisant le texte à partir de
      # tous les mots/ponctuations ?

      # On prend le tout premier mot
      debug('* Récupération du tout premier mot avec proximités…')
      pointe_premier_mot_avec_proximites
      debug('= POINTEURS = %s' % POINTEURS.inspect)

      while # tant qu'on ne procède pas à la fin

        # On passe ici soit pour prendre une proximité suivante ou précédente
        # du mot courant, soit pour passer à un mot suivant ou précédant


        # POINTEURS[:mot] et POINTEURS[:prox] déterminent la proximité à voir.

        # S'il n'y a pas de proximité avec le mot courant, on passe
        # au mot suivant
        POINTEURS[:nombre_proximites_mot] > 0 || begin
          if cherche_mot_suivant_avec_proximites
            # <= Un mot suivant a pu être trouvé
            # => il a été mis en pointeur, on l'affiche
          else
            # <= Il n'y a pas de mot suivant avec des proximités
            # => On propose soit de s'arrêter, soit de passer à la suite
            if confirmation?('Nous avons atteint la fin de la liste. Reprendre au début ?', ['o', 'y'], ['o', 'y', 'n'])
              reset_pointeurs_pour_mot_at(0)
            else
              break
            end
          end
        end

        # --- Proximité à afficher ---
        # Note : normalement, ici, son existence doit avoir été vérifiée.
        iprox = get_proximite_courante

        # ==== AFFICHAGE LIGNE D'ENTÊTE ====
        winheader.affiche(header_with_data(iprox, POINTEURS), line: 1, style: [:bleu, :gras])

        # On règle les décalages de départ et de fin du binder-item contenant
        # le/les mots
        [iprox.mot_avant, iprox.mot_apres].each do |imot|
          imot.binder_item.offset_start || imot.set_offsets_bitem(tableau[:binder_items])
        end

        # ==== AFFICHAGE DU BLOC DE PROXIMITÉ (extrait) =====
        winup.clear
        winup.sput(iprox.line_with_words_and_distance, style: :rouge)
        # winup.affiche(SEPARATEURS[:guils], line: indice_line)
        winup.sput(SEPARATEURS[:plats], style: :rouge)
        iprox.extrait.each_with_index do |data_line, index_extrait|
          winup.sput(data_line[0], data_line[1])
        end
        winup.sput(SEPARATEURS[:plats], style: :rouge)

        # Demande sur la suite à faire
        # Soit la méthode retourne TRUE et on poursuit, soit elle retourne
        # FALSE et on s'arrête là.
        attendre_decision_user_et_traiter(windown, iprox) || break

      end
      # /fin de boucle sur tous les mots à proximité et leurs proximités
      
    rescue Exception => e
      debug(e)
      winup.affiche(e.message)
      winup.affiche(String::RC + e.backtrace[0..1].join(String::RC))
      winup.affiche(String::RC + 'Voir la suite dans le log de débug', :rouge)
      sleep 4
    end

    # Il faut voir s'il faut sauver
    # TODO : lorsqu'on pourra régler la sauvegarde automatique, on pourra
    # le faire sans demander
    if project.modified?
      if confirmation?('Le projet a été modifié. Dois-je le sauver ?', ['o','y'], ['o','y', 'n'])
        project.save_proximites
      end
    end

  rescue Exception => e
    debug(e)
    winup.affiche(e.message)
    winup.affiche(String::RC + e.backtrace[0..1].join(String::RC))
    sleep 4
  ensure
    winheader && winheader.close
    winup     && winup.close
    windown   && windown.close
    Curses.close_screen
  end
  # /output


end #/<< self
end #/Console
end #/Project
end #/Scriver
